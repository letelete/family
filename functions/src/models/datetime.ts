import * as Admin from "firebase-admin";

export const fromServerFormat = (date: Admin.firestore.Timestamp): Date => {
  return date.toDate();
};

export const toServerFormat = (date: Date): Admin.firestore.Timestamp => {
  return Admin.firestore.Timestamp.fromDate(date);
};

export const normalize = (date: Date): Date => {
  const timestamp = toServerFormat(date);
  return fromServerFormat(timestamp);
};  

export const nowUtc = (): Date => {
  const timestampNow = Admin.firestore.Timestamp.now();
  return timestampNow.toDate();
};
