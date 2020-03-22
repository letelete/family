import * as DateTime from "../../src/models/datetime";
import { expect } from "chai";

describe("DateTime normalization", () => {
  it("Should return valid date object from given timestamp", () => {
    // Wednesday, 1 January 2020 12:00:00
    // Generated with https://www.epochconverter.com/
    const date = new Date("2020-01-01T12:00:00Z");
    const dateAsTimestamp = DateTime.toServerFormat(date);
    const dateFromServerFormat = DateTime.fromServerFormat(dateAsTimestamp);
    expect(dateFromServerFormat).to.deep.equal(date);
  });

  it("Should return valid timestamp from given date object", () => {
    // Wednesday, 1 January 2020 12:00:00
    // Generated with https://www.epochconverter.com/
    const date = new Date("2020-01-01T12:00:00Z");
    const dateAsTimestamp = {
      _seconds: 1577880000,
      _nanoseconds: 0
    };
    const serverDateFormat = DateTime.toServerFormat(date);
    expect(serverDateFormat).to.deep.equal(dateAsTimestamp);
  });
});
