import * as SubscriptionOptions from "./subscription_options_contract";
import {
  OptionsDeserialization,
  OptionsSerialization
} from "../../models/task";

export const Fields = SubscriptionOptions.Fields;

export interface Contract extends SubscriptionOptions.Contract {}

export const serialize: OptionsSerialization<Contract> =
  SubscriptionOptions.serialize;

export const deserialize: OptionsDeserialization<Contract> =
  SubscriptionOptions.deserialize;
