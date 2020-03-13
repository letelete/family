import * as Subscription from "../schedule/subscription";
import * as DateTime from "./datetime";

export class Fields {
  static readonly id: string = "id";
  static readonly paymentDay: string = "payment_day";
  static readonly subscriptionType: string = "subscription_type";
  static readonly treshold: string = "treshold_between_payments";
}

export interface Model {
  id: string;
  paymentDay: Date;
  subscriptionType: Subscription.Type;
  treshold: number;
}

export const serialize = (data: Model): any => {
  const paymentDay = DateTime.toServerFormat(data.paymentDay);
  const treshold = data.treshold || 1;
  return {
    [Fields.id]: data.id,
    [Fields.paymentDay]: paymentDay,
    [Fields.subscriptionType]: data.subscriptionType,
    [Fields.treshold]: treshold
  };
};

export const deserialize = (data: any): Model => {
  const rawDate = data[Fields.paymentDay];
  const paymentDay = DateTime.fromServerFormat(rawDate);
  const treshold = data[Fields.treshold] || 1;
  const model: Model = {
    id: data[Fields.id],
    paymentDay: paymentDay,
    subscriptionType: data[Fields.subscriptionType],
    treshold: treshold
  };
  return model;
};
