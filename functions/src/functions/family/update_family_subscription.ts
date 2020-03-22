import * as Admin from "firebase-admin";
import * as Functions from "firebase-functions";
import * as Family from "../../models/family";
import * as FamilySubscription from "../../schedule/family_subscription_schedule";

const documentPath = "users/{userId}/families/{familyId}";

enum Response {
  update,
  dontUpdate,
  undefinedChanges,
  familyDeleted,
  familyCreated
}

export const updateFamilySubscription = Functions.firestore
  .document(documentPath)
  .onWrite(async (change, _) => {
    const response = getWriteResponse(change);
    const oldFamilyData = change?.before?.data();
    const newFamilyData = change?.after?.data();

    switch (response) {
      case Response.familyCreated:
      case Response.update:
        const newFamily = Family.deserialize(newFamilyData);
        return scheduleSubscription(newFamily);
      case Response.familyDeleted:
        const oldFamily = Family.deserialize(oldFamilyData);
        return deleteSubscription(oldFamily);
      case Response.undefinedChanges:
        console.error("Both data fields of Change object are undefined");
        return null;
    }

    return null;
  });

const getWriteResponse = (
  change: Functions.Change<Admin.firestore.DocumentSnapshot>
): Response => {
  const before = change.before?.data();
  const after = change.after?.data();

  if (!before && !after) return Response.undefinedChanges;

  if (!before && after) return Response.familyCreated;

  if (before && !after) return Response.familyDeleted;

  if (before && after) {
    const shouldUpdate = changesNeedUpdate(before, after);
    if (shouldUpdate) return Response.update;
  }

  return Response.dontUpdate;
};

const changesNeedUpdate = (
  before: Admin.firestore.DocumentData,
  after: Admin.firestore.DocumentData
): boolean => {
  if (before === after) return false;

  const familyBefore = Family.deserialize(before);
  const familyAfter = Family.deserialize(after);

  const paymentDateDiffer = familyAfter.paymentDay !== familyBefore.paymentDay;
  const subscriptionDateDiffer =
    familyAfter.subscriptionType !== familyBefore.subscriptionType;
  const tresholdDiffer = familyAfter.treshold !== familyBefore.treshold;

  return paymentDateDiffer || subscriptionDateDiffer || tresholdDiffer;
};

const deleteSubscription = async (family: Family.Model) => {
  const sourceId = family.id;
  return FamilySubscription.deleteSubscription(sourceId).catch(error => {
    console.error(error);
  });
};

const scheduleSubscription = async (family: Family.Model) => {
  return FamilySubscription.scheduleSubscription(family);
};
