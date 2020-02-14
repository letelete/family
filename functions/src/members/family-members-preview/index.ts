import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

export const updateFamilyMembersPreview = functions.firestore
  .document("users/{userId}/families/{familyId}/members/{memberId}")
  .onWrite(async (change, context) => {
    const oldMemberData = change.before.data();
    const newMemberData = change.after.data();
    if (newMemberData === oldMemberData) return null;

    const memberDoc = (change.after || change.before).ref;
    const familyDoc = memberDoc?.parent?.parent;
    if (!familyDoc) {
      console.error("Family documentReference is null");
      return null;
    }

    try {
      if (!newMemberData && oldMemberData) {
        return removeFromPreview(familyDoc, oldMemberData);
      } else if (!newMemberData) {
        console.error("Both documents of member data are null");
        return null;
      }
      const updatedPreview = await getUpdatedPreviewIfMemberExists(
        familyDoc,
        newMemberData
      ).catch(error => {
        console.error(error);
        return null;
      });
      if (updatedPreview) return setPreview(familyDoc, updatedPreview);
      else return appendMemberToPreview(familyDoc, newMemberData);
    } catch (error) {
      console.error(error);
    }

    return null;
  });

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
  const familyData = await familyDoc
    .get()
    .then(snapshot => snapshot.data())
    .catch(error => console.error(error));
  if (!familyData) return null;

  const membersPreview = familyData.members_preview;
  let memberIndex = undefined;
  for (const index in membersPreview) {
    const memberExistInArray = membersPreview[index].id === memberData.id;
    if (memberExistInArray) {
      memberIndex = index;
      break;
    }
  }
  if (memberIndex) {
    membersPreview[memberIndex] = getMemberPreview(memberData);
    return membersPreview;
  }
  return null;
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
