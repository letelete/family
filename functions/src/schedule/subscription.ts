import * as DateTime from "../models/datetime";

export const enum Type {
  weekly = "weekly",
  monthly = "monthly",
  yearly = "yearly"
}

export const subscriptionExpired = (paymentDay: Date) => {
  const today = DateTime.nowUtc();
  return paymentDay <= today;
};

/**
 * Returns the next date of specified subscription
 * @param initialDate The base date on which all calculations depend
 * @param type The type of the subscription
 * @param tresholdBetweenPayments The intensity of payments within given type.
 * @sample For type = FamilySubscriptionType.weekly, and tresholdBetweenPayments = 3, the next subscription would fire in next 3(tresholdBetweenPayments) weeks(type)
 * @throws {Error} if given treshold is not a positive number
 */
export const getNextDateOfSubscription = (
  initialDate: Date,
  type: Type,
  tresholdBetweenPayments: number = 1
): Date => {
  if (tresholdBetweenPayments <= 0) {
    throw Error("Treshold must be a positive number");
  }
  switch (type) {
    case Type.weekly:
      initialDate.setDate(initialDate.getDate() + 7 * tresholdBetweenPayments);
      break;
    case Type.monthly:
      initialDate.setMonth(initialDate.getMonth() + tresholdBetweenPayments);
      break;
    case Type.yearly:
      initialDate.setFullYear(
        initialDate.getFullYear() + tresholdBetweenPayments
      );
      break;
  }
  return initialDate;
};
