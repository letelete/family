import * as Admin from "firebase-admin";
import * as Task from "../models/task";
import * as Family from "../models/family";
import * as Error from "./exceptions";
import * as SubscriptionOptions from "../schedule/contracts/subscription_options_contract";
import * as DateTime from "../models/datetime";

const db = Admin.firestore();

class Collection {
  static readonly tasks = "tasks";
  static readonly families = "families";
}

/**
 * Schedules given task
 * @param task The task model with updated data
 * @param serialization The serialization contract describing the way of serializing the @param {task}
 * @throws {TransactionError} when there was an error while fetching tasks snapshot
 * @throws {AddNewSubscriptionError} on unsuccessful new task addition
 * @throws {UpdateSubscriptionError} on unsuccessful already existing task updation
 */
export const scheduleNewSubscriptionOrUpdate = async (
  task: Task.Model<SubscriptionOptions.Contract>
): Promise<any> => {
  const serializedTask = Task.serialize(task, SubscriptionOptions.serialize);
  const optionsField = Task.Fields.options;
  const sourceIdField = SubscriptionOptions.Fields.sourceId;
  const query = db.collection(Collection.tasks);
  const snapshot = await query
    .where(`${optionsField}.${sourceIdField}`, "==", task.options.sourceId)
    .limit(1)
    .get()
    .catch(error => {
      throw new Error.TransactionError(error);
    });
  if (snapshot.empty) {
    return query.add(serializedTask).catch(error => {
      throw new Error.AddNewSubscriptionError(error);
    });
  } else {
    const document = snapshot.docs[0];
    return document.ref.update(serializedTask).catch(error => {
      throw new Error.UpdateSubscriptionError(error);
    });
  }
};

/**
 * Deletes subscription by given source id
 * @param sourceId The id of source of the subscription
 * @throws {TransactionError} when there was an error while fetching tasks snapshot
 * @throws {DeleteSubscriptionError} on unsuccessful subscription deletion
 */
export const deleteSubscription = async (sourceId: string): Promise<any> => {
  const optionsField = Task.Fields.options;
  const sourceIdField = SubscriptionOptions.Fields.sourceId;
  const snapshot = await db
    .collection(Collection.tasks)
    .where(`${optionsField}.${sourceIdField}`, "==", sourceId)
    .limit(1)
    .get()
    .catch(error => {
      throw new Error.TransactionError(error);
    });
  const document = snapshot.docs[0];
  return document.ref.delete().catch(error => {
    throw new Error.DeleteSubscriptionError(error);
  });
};

/**
 * Fetches tasks older or equal to the given @param {date}
 * @throws {TransactionError} on unsuccessful family fetch
 */
export const getTasksOlderOrEqual = async (
  date: Date,
  status: Task.Status
): Promise<Admin.firestore.QuerySnapshot<
  Admin.firestore.DocumentData
> | null> => {
  const normalizedDate = DateTime.normalize(date);
  return await db
    .collection(Collection.tasks)
    .where(Task.Fields.performAt, "<=", normalizedDate)
    .where(Task.Fields.status, "==", status)
    .get()
    .catch(error => {
      throw new Error.TransactionError(error);
    });
};

/**
 * Updates family with given @param {family} model data
 * @param family The model of data which will override actual family' one
 * @throws {TransactionError} when there was an error while fetching family snapshot
 * @throws {NoFamilyFoundError} on no family results in the database
 */
export const updateFamily = async (family: Family.Model): Promise<any> => {
  const serializedFamily = Family.serialize(family);
  const snapshot = await db
    .collectionGroup(Collection.families)
    .where(Family.Fields.id, "==", family.id)
    .limit(1)
    .get()
    .catch(error => {
      throw new Error.TransactionError(error);
    });
  if (snapshot.empty) {
    throw new Error.NoFamilyFoundError(
      `No family found with given id: ${family.id}`
    );
  }
  const document = snapshot.docs[0];
  return document.ref.update(serializedFamily);
};
