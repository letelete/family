export class NoTaskFoundError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "NoTaskFoundError";
    Error.captureStackTrace(this, NoTaskFoundError);
  }
}

export class NoFamilyFoundError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "NoFamilyFoundError";
    Error.captureStackTrace(this, NoFamilyFoundError);
  }
}

export class TransactionError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "TransactionError";
    Error.captureStackTrace(this, TransactionError);
  }
}

export class AddNewSubscriptionError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "AddNewSubscriptionError";
    Error.captureStackTrace(this, AddNewSubscriptionError);
  }
}

export class UpdateSubscriptionError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "UpdateSubscriptionError";
    Error.captureStackTrace(this, UpdateSubscriptionError);
  }
}

export class DeleteSubscriptionError extends Error {
  constructor(message: string) {
    super(message);
    this.name = "DeleteSubscriptionError";
    Error.captureStackTrace(this, DeleteSubscriptionError);
  }
}
