import * as Task from "../models/task";
import * as Family from "../models/family";
import * as Database from "../database/database";
import * as Subscription from "./subscription";
import * as FamilyOptions from "./contracts/family_options_contract";

import { NoFamilyFoundError } from "../database/exceptions";

export const key: string = "familySubscription";

export const onSubscriptionRecurrence = async (
  task: Task.Model<FamilyOptions.Contract>
): Promise<any> => {
  return updateTaskFields(task);
};

export const updateTaskFields = async (
  task: Task.Model<FamilyOptions.Contract>
): Promise<any> => {
  try {
    const nextExecutionDate = getNextExecutionDate(
      task.performAt,
      task.options.subscriptionType,
      task.options.treshold
    );
    const updatedTask: Task.Model<FamilyOptions.Contract> = {
      performAt: nextExecutionDate,
      status: Task.Status.scheduled,
      worker: task.worker,
      options: {
        paymentDay: nextExecutionDate,
        sourceId: task.options.sourceId,
        subscriptionType: task.options.subscriptionType,
        treshold: task.options.treshold
      }
    };
    await Database.scheduleNewSubscriptionOrUpdate(updatedTask);
    return updateFamilySource(updatedTask);
  } catch (error) {
    console.error(error.message, task);
  }
  return null;
};

export const scheduleSubscription = async (
  family: Family.Model
): Promise<any> => {
  try {
    const nextExecutionDate = getNextExecutionDate(
      family.paymentDay,
      family.subscriptionType,
      family.treshold
    );
    const task: Task.Model<FamilyOptions.Contract> = {
      performAt: nextExecutionDate,
      status: Task.Status.scheduled,
      worker: key,
      options: {
        paymentDay: nextExecutionDate,
        sourceId: family.id,
        subscriptionType: family.subscriptionType,
        treshold: family.treshold
      }
    };
    await Database.scheduleNewSubscriptionOrUpdate(task);
    return updateFamilySource(task);
  } catch (error) {
    console.error(error, family);
  }
  return null;
};

export const updateFamilySource = async (
  task: Task.Model<FamilyOptions.Contract>
): Promise<any> => {
  const sourceId = task.options.sourceId;
  const family: Family.Model = {
    id: sourceId,
    paymentDay: task.options.paymentDay,
    subscriptionType: task.options.subscriptionType,
    treshold: task.options.treshold
  };
  return Database.updateFamily(family).catch(error => {
    console.error(error);
    if (error instanceof NoFamilyFoundError) {
      return deleteSubscription(task.options.sourceId);
    }
    return null;
  });
};

export const deleteSubscription = async (sourceId: string): Promise<any> => {
  return Database.deleteSubscription(sourceId).catch(error =>
    console.error("Error while deleting the subscription", error)
  );
};

const getNextExecutionDate = (
  currentDate: Date,
  type: Subscription.Type,
  tresholdBetweenPayments: number = 1
) => {
  let nextExecutionDate = currentDate;
  const subscriptionExpired = Subscription.subscriptionExpired(currentDate);
  if (subscriptionExpired) {
    nextExecutionDate = Subscription.getNextDateOfSubscription(
      currentDate,
      type,
      tresholdBetweenPayments
    );
  }
  return nextExecutionDate;
};
