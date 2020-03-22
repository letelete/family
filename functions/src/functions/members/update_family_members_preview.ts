import * as Admin from "firebase-admin";
import * as Functions from "firebase-functions";

export const updateFamilyMembersPreview = Functions.firestore
  .document("users/{userId}/families/{familyId}/members/{memberId}")
  .onWrite(async (change, context) => {
    const oldMemberData = change.before.data();
    const newMemberData = change.after.data();
    const memberDoc = (change.after || change.before).ref;
    const familyDoc = memberDoc?.parent?.parent;
    const noUpdateRequired = !hasPreviewRelatedChanges(
      oldMemberData,
      newMemberData
    );

    if (noUpdateRequired) return null;
    if (!familyDoc) {
      console.error("Family documentReference is null");
      return null;
    }

    try {
      if (!newMemberData && oldMemberData) {
        return removeFromPreview(familyDoc, oldMemberData);
      } else if (!newMemberData) {
        // unreachable
        return null;
      }
      return await getUpdatedPreviewIfMemberExists(familyDoc, newMemberData)
        .then(previewWithMember =>
          previewWithMember
            ? setPreview(familyDoc, previewWithMember)
            : appendMemberToPreview(familyDoc, newMemberData)
        )
        .catch(error => {
          console.error(error);
          return null;
        });
    } catch (error) {
      console.error(error);
    }

    return null;
  });

function hasPreviewRelatedChanges(
  oldMember: Admin.firestore.DocumentData | undefined,
  newMember: Admin.firestore.DocumentData | undefined
): Boolean {
  if (!oldMember && !newMember) {
    console.error("Both member data documents are null");
    return false;
  }
  if (oldMember === newMember) return false;
  const previewRelatedChangesMade =
    oldMember?.name !== newMember?.name ||
    oldMember?.photo_url !== newMember?.photo_url;
  return previewRelatedChangesMade;
}

function removeFromPreview(
  familyDoc: Admin.firestore.DocumentReference,
  oldMemberData: Admin.firestore.DocumentData
): Promise<Admin.firestore.WriteResult> {
  const oldMemberPreview = getMemberPreview(oldMemberData);
  return familyDoc.update({
    members_preview: Admin.firestore.FieldValue.arrayRemove(oldMemberPreview)
  });
}

async function getUpdatedPreviewIfMemberExists(
  familyDoc: Admin.firestore.DocumentReference,
  memberData: Admin.firestore.DocumentData
): Promise<Admin.firestore.DocumentData | null> {
  const familyData = await getFamilyData(familyDoc);
  if (!familyData) throw new Error("Family data is null");

  const memberAlreadyInArray = (element: Admin.firestore.DocumentData) => {
    return element.id === memberData.id;
  };
  const index = familyData.members_preview.findIndex(memberAlreadyInArray);
  if (index === -1) return null;

  familyData.members_preview[index] = getMemberPreview(memberData);
  return familyData.members_preview;
}

async function getFamilyData(
  familyDoc: Admin.firestore.DocumentReference
): Promise<Admin.firestore.DocumentData | undefined> {
  return await familyDoc
    .get()
    .then(snapshot => snapshot.data())
    .catch(error => {
      console.error(error);
      return undefined;
    });
}

function setPreview(
  familyDoc: Admin.firestore.DocumentReference,
  previewData: object
): Promise<Admin.firestore.WriteResult> {
  return familyDoc.set({ members_preview: previewData }, { merge: true });
}

function appendMemberToPreview(
  familyDoc: Admin.firestore.DocumentReference,
  memberData: Admin.firestore.DocumentData
): Promise<Admin.firestore.WriteResult> {
  const memberPreview = getMemberPreview(memberData);
  return familyDoc.update({
    members_preview: Admin.firestore.FieldValue.arrayUnion(memberPreview)
  });
}

function getMemberPreview(memberData: Admin.firestore.DocumentData): object {
  return {
    id: memberData.id,
    name: memberData.name,
    photo_url: memberData.photo_url,
    created_at: memberData.created_at
  };
}
