import * as Functions from "firebase-functions";
import * as Task from "../models/task";
import * as FamilySubscription from "./family_subscription_schedule";
import * as Database from "../database/database";
import * as FamilyOptions from "./contracts/family_options_contract";
import * as DateTime from "../models/datetime";

interface Workers {
  [key: string]: (options: any) => Promise<any>;
}

interface Deserializators {
  [workerKey: string]: Task.OptionsDeserialization<any>;
}

const workers: Workers = {
  [FamilySubscription.key]: (task: Task.Model<FamilyOptions.Contract>) =>
    FamilySubscription.onSubscriptionRecurrence(task)
};

const deserialization: Deserializators = {
  [FamilySubscription.key]: FamilyOptions.deserialize
};

export const tasksRunner = Functions.runWith({ memory: "2GB" })
  .pubsub.schedule("* * * * *")
  .onRun(async context => {
    const now = DateTime.nowUtc();
    const requiredStatus = Task.Status.scheduled;
    const jobs: Promise<any>[] = [];

    const tasks = await Database.getTasksOlderOrEqual(
      now,
      requiredStatus
    ).catch(error =>
      console.error(`Error while fetching scheduled tasks ${error.message}`)
    );

    if (!tasks) return null;

    tasks.forEach(snapshot => {
      const data = snapshot.data();
      const deserializer = deserialization[data.worker];
      const task: Task.Model<any> = Task.deserialize(data, deserializer);
      const job = workers[task.worker](task).catch(error => {
        console.error(error);
        return snapshot.ref.update({ status: Task.Status.error });
      });

      jobs.push(job);
    });

    return await Promise.all(jobs);
  });
