import * as Subscription from "../../src/schedule/subscription";
import { describe, it } from "mocha";

const expect = require("chai").expect;
require("../chai_extensions");

describe("Next subscription date", () => {
  it("Should left the time as is", function() {
    // 2020/01/01 24:00:13.400
    const initialDate = new Date(2020, 0, 1, 24, 0, 13, 400);
    const expected = new Date(2020, 0, 1, 24, 0, 13, 400);

    const tresholdBetweenPaymentsInWeeks = 1;
    const subscriptionType = Subscription.Type.monthly;

    const actual = Subscription.getNextDateOfSubscription(
      initialDate,
      subscriptionType,
      tresholdBetweenPaymentsInWeeks
    );

    expect(actual).equalTime(expected);
  });

  describe("Weekly subscription", () => {
    it("Should change the date by 7 days", function() {
      const initialDate = new Date(2020, 0, 1);
      const expected = new Date(2020, 0, 8);

      const tresholdBetweenPaymentsInWeeks = 1;
      const subscriptionType = Subscription.Type.weekly;

      const actual = Subscription.getNextDateOfSubscription(
        initialDate,
        subscriptionType,
        tresholdBetweenPaymentsInWeeks
      );

      expect(actual).equalDate(expected);
    });

    it("Should change the date by 14 days", function() {
      const initialDate = new Date(2020, 0, 4);
      const expected = new Date(2020, 0, 18);

      const tresholdBetweenPaymentsInWeeks = 2;
      const subscriptionType = Subscription.Type.weekly;

      const actual = Subscription.getNextDateOfSubscription(
        initialDate,
        subscriptionType,
        tresholdBetweenPaymentsInWeeks
      );

      expect(actual).equalDate(expected);
    });

    it("Should change the date by 28 days and months by 1", function() {
      const initialDate = new Date(2020, 0, 10);
      const expected = new Date(2020, 1, 7);

      const tresholdBetweenPaymentsInWeeks = 4;
      const subscriptionType = Subscription.Type.weekly;

      const actual = Subscription.getNextDateOfSubscription(
        initialDate,
        subscriptionType,
        tresholdBetweenPaymentsInWeeks
      );

      expect(actual).equalDate(expected);
    });
  });

  describe("Monthly subscription", () => {
    it("Should change the date by 1 month", function() {
      const january = 0;
      const februrary = 1;
      const initialDate = new Date(2020, january, 26);
      const expected = new Date(2020, februrary, 26);

      const tresholdBetweenPaymentsInMonths = 1;
      const subscriptionType = Subscription.Type.monthly;

      const actual = Subscription.getNextDateOfSubscription(
        initialDate,
        subscriptionType,
        tresholdBetweenPaymentsInMonths
      );

      expect(actual).equalDate(expected);
    });

    it("Should change the date by 5 months and year by 1", function() {
      const october = 9;
      const march = 2;
      const initialDate = new Date(2020, october, 1);
      const expected = new Date(2021, march, 1);

      const tresholdBetweenPaymentsInMonths = 5;
      const subscriptionType = Subscription.Type.monthly;

      const actual = Subscription.getNextDateOfSubscription(
        initialDate,
        subscriptionType,
        tresholdBetweenPaymentsInMonths
      );

      expect(actual).equalDate(expected);
    });
  });

  describe("Yearly subscription", () => {
    it("Should change the date by 1 year", function() {
      const initialDate = new Date(2020, 0, 26);
      const expected = new Date(2021, 0, 26);

      const tresholdBetweenPaymentsInYears = 1;
      const subscriptionType = Subscription.Type.yearly;

      const actual = Subscription.getNextDateOfSubscription(
        initialDate,
        subscriptionType,
        tresholdBetweenPaymentsInYears
      );

      expect(actual).equalDate(expected);
    });

    it("Should change the date by 10 years", function() {
      const initialDate = new Date(2020, 0, 26);
      const expected = new Date(2030, 0, 26);

      const tresholdBetweenPaymentsInYears = 10;
      const subscriptionType = Subscription.Type.yearly;

      const actual = Subscription.getNextDateOfSubscription(
        initialDate,
        subscriptionType,
        tresholdBetweenPaymentsInYears
      );

      expect(actual).equalDate(expected);
    });
  });
});
