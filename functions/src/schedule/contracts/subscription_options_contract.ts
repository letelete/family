import {
  OptionsContract,
  OptionsDeserialization,
  OptionsSerialization
} from "../../models/task";
import { Type } from "../subscription";

import * as DateTime from "../../models/datetime";

export class Fields {
  static readonly paymentDay: string = "payment_day";
  static readonly treshold: string = "treshold_between_payments";
  static readonly sourceId: string = "source_id";
  static readonly subscriptionType: string = "subscription_type";
}

export interface Contract extends OptionsContract {
  paymentDay: Date;
  treshold: number;
  sourceId: string;
  subscriptionType: Type;
}

export const serialize: OptionsSerialization<Contract> = (
  options: Contract
) => {
  const paymentDay = DateTime.toServerFormat(options.paymentDay);
  return {
    [Fields.paymentDay]: paymentDay,
    [Fields.treshold]: options.treshold,
    [Fields.sourceId]: options.sourceId,
    [Fields.subscriptionType]: options.subscriptionType
  };
};

export const deserialize: OptionsDeserialization<Contract> = (raw: any) => {
  const paymentDay = DateTime.fromServerFormat(raw[Fields.paymentDay]);
  const options: Contract = {
    paymentDay: paymentDay,
    treshold: raw[Fields.treshold],
    sourceId: raw[Fields.sourceId],
    subscriptionType: raw[Fields.subscriptionType]
  };
  return options;
};
