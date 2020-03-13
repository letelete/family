import * as Task from "../../src/models/task";
import * as FamilyOptions from "../../src/schedule/contracts/family_options_contract";
import * as FamilySubscription from "../../src/schedule/family_subscription_schedule";
import * as Subscription from "../../src/schedule/subscription";
import * as DateTime from "../../src/models/datetime";

import { describe, it } from "mocha";
import { expect } from "chai";

describe("Family task", () => {
  it("Should deserialize", () => {
    const todayDate = new Date(2020, 0, 5);
    const serverDateFormat = DateTime.toServerFormat(todayDate);
    const normalizedDateFormat = DateTime.fromServerFormat(serverDateFormat);

    const rawData = {
      [Task.Fields.worker]: "familySubscription",
      [Task.Fields.status]: "scheduled",
      [Task.Fields.performAt]: serverDateFormat,
      [Task.Fields.options]: {
        [FamilyOptions.Fields.paymentDay]: serverDateFormat,
        [FamilyOptions.Fields.sourceId]: "id",
        [FamilyOptions.Fields.subscriptionType]: "monthly",
        [FamilyOptions.Fields.treshold]: 1
      }
    };

    const expected: Task.Model<FamilyOptions.Contract> = {
      worker: FamilySubscription.key,
      performAt: normalizedDateFormat,
      status: Task.Status.scheduled,
      options: {
        paymentDay: normalizedDateFormat,
        sourceId: "id",
        subscriptionType: Subscription.Type.monthly,
        treshold: 1
      }
    };

    const deserialized = Task.deserialize(rawData, FamilyOptions.deserialize);
    expect(deserialized).to.deep.equal(expected);
  });

  it("Should serialize", () => {
    const todayDate = new Date(2020, 0, 5);
    const serverDateFormat = DateTime.toServerFormat(todayDate);
    const normalizedDateFormat = DateTime.fromServerFormat(serverDateFormat);

    const model: Task.Model<FamilyOptions.Contract> = {
      worker: FamilySubscription.key,
      performAt: normalizedDateFormat,
      status: Task.Status.scheduled,
      options: {
        paymentDay: normalizedDateFormat,
        sourceId: "id",
        subscriptionType: Subscription.Type.monthly,
        treshold: 2
      }
    };

    const expected = {
      [Task.Fields.worker]: "familySubscription",
      [Task.Fields.status]: "scheduled",
      [Task.Fields.performAt]: serverDateFormat,
      [Task.Fields.options]: {
        [FamilyOptions.Fields.paymentDay]: serverDateFormat,
        [FamilyOptions.Fields.sourceId]: "id",
        [FamilyOptions.Fields.subscriptionType]: "monthly",
        [FamilyOptions.Fields.treshold]: 2
      }
    };

    const serialized = Task.serialize(model, FamilyOptions.serialize);
    expect(serialized).to.deep.equal(expected);
  });

  it("Serialized data should be equal to its deserialized and serialized back copy", () => {
    const todayDate = new Date(2020, 0, 5);
    const serverDateFormat = DateTime.toServerFormat(todayDate);

    const serializedOrigin = {
      [Task.Fields.worker]: "familySubscription",
      [Task.Fields.status]: "scheduled",
      [Task.Fields.performAt]: serverDateFormat,
      [Task.Fields.options]: {
        [FamilyOptions.Fields.paymentDay]: serverDateFormat,
        [FamilyOptions.Fields.sourceId]: "id",
        [FamilyOptions.Fields.subscriptionType]: "monthly",
        [FamilyOptions.Fields.treshold]: 2
      }
    };

    const deserialized = Task.deserialize(
      serializedOrigin,
      FamilyOptions.deserialize
    );

    const serializedBack = Task.serialize(
      deserialized,
      FamilyOptions.serialize
    );

    expect(serializedOrigin).to.deep.equal(serializedBack);
  });

  it("Deserialized data should be equal to its serialized and deserialized back copy", () => {
    const todayDate = new Date(2020, 0, 5);
    const serverDateFormat = DateTime.toServerFormat(todayDate);
    const normalizedDateFormat = DateTime.fromServerFormat(serverDateFormat);

    const deserializedOrigin: Task.Model<FamilyOptions.Contract> = {
      worker: FamilySubscription.key,
      performAt: normalizedDateFormat,
      status: Task.Status.scheduled,
      options: {
        paymentDay: normalizedDateFormat,
        sourceId: "id",
        subscriptionType: Subscription.Type.monthly,
        treshold: 2
      }
    };

    const serialized = Task.serialize(
      deserializedOrigin,
      FamilyOptions.serialize
    );

    const deserializedBack = Task.deserialize(
      serialized,
      FamilyOptions.deserialize
    );

    expect(deserializedOrigin).to.deep.equal(deserializedBack);
  });
});
