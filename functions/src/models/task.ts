import * as Admin from "firebase-admin";
import * as DateTime from "./datetime";

export class Fields {
  static readonly worker: string = "worker";
  static readonly performAt: string = "perform_at";
  static readonly status: string = "status";
  static readonly options: string = "options";
}

export interface OptionsContract {}

export interface OptionsSerialization<T extends OptionsContract> {
  (options: T): any;
}

export interface OptionsDeserialization<T extends OptionsContract> {
  (raw: any): T;
}

export interface Model<T extends OptionsContract> {
  worker: string;
  performAt: Date;
  status: Status;
  options: T;
}

export const enum Status {
  scheduled = "scheduled",
  completed = "completed",
  error = "error"
}

export const serialize = (
  task: Model<any>,
  serialization: OptionsSerialization<any>
): any => {
  if (!task) {
    return {
      [Fields.status]: Status.error
    };
  }
  const performAt = DateTime.toServerFormat(task.performAt);
  return {
    [Fields.worker]: task.worker,
    [Fields.performAt]: performAt,
    [Fields.status]: task.status,
    [Fields.options]: serialization(task.options)
  };
};

export const deserialize = (
  task: Admin.firestore.DocumentData,
  deserialization: OptionsDeserialization<OptionsContract>
): Model<OptionsContract> => {
  const performAt = DateTime.fromServerFormat(task[Fields.performAt]);
  return {
    worker: task[Fields.worker],
    performAt: performAt,
    status: task[Fields.status],
    options: deserialization(task[Fields.options])
  };
};
