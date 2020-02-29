import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

export const updateFamilyMembersPreview = functions.firestore
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
  oldMember: FirebaseFirestore.DocumentData | undefined,
  newMember: FirebaseFirestore.DocumentData | undefined
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
  familyDoc: FirebaseFirestore.DocumentReference,
  oldMemberData: FirebaseFirestore.DocumentData
): Promise<FirebaseFirestore.WriteResult> {
  console.log(`Removing ${oldMemberData.id} from the family preview`);
  const oldMemberPreview = getMemberPreview(oldMemberData);
  return familyDoc.update({
    members_preview: admin.firestore.FieldValue.arrayRemove(oldMemberPreview)
  });
}

async function getUpdatedPreviewIfMemberExists(
  familyDoc: FirebaseFirestore.DocumentReference,
  memberData: FirebaseFirestore.DocumentData
): Promise<FirebaseFirestore.DocumentData | null> {
  const familyData = await getFamilyData(familyDoc);
  if (!familyData) throw new Error("Family data is null");

  const memberAlreadyInArray = (element: FirebaseFirestore.DocumentData) => {
    return element.id === memberData.id;
  };
  const index = familyData.members_preview.findIndex(memberAlreadyInArray);
  if (index === -1) return null;

  familyData.members_preview[index] = getMemberPreview(memberData);
  return familyData.members_preview;
}

async function getFamilyData(
  familyDoc: FirebaseFirestore.DocumentReference
): Promise<FirebaseFirestore.DocumentData | undefined> {
  return await familyDoc
    .get()
    .then(snapshot => snapshot.data())
    .catch(error => {
      console.error(error);
      return undefined;
    });
}

function setPreview(
  familyDoc: FirebaseFirestore.DocumentReference,
  previewData: object
): Promise<FirebaseFirestore.WriteResult> {
  console.log(`Setting a new family preview`);
  return familyDoc.set({ members_preview: previewData }, { merge: true });
}

function appendMemberToPreview(
  familyDoc: FirebaseFirestore.DocumentReference,
  memberData: FirebaseFirestore.DocumentData
): Promise<FirebaseFirestore.WriteResult> {
  console.log(`Appending ${memberData.id} to the family preview`);
  const memberPreview = getMemberPreview(memberData);
  return familyDoc.update({
    members_preview: admin.firestore.FieldValue.arrayUnion(memberPreview)
  });
}

function getMemberPreview(memberData: FirebaseFirestore.DocumentData): object {
  return {
    id: memberData.id,
    name: memberData.name,
    photo_url: memberData.photo_url,
    created_at: memberData.created_at
  };
}
