const Assertion = require("chai").Assertion;

Assertion.addMethod("equalTime", function(this: any, time: Date) {
  const expected = time;
  const actual = this._obj.getTime();

  const hoursEqual = time.getHours() === this._obj.getHours();
  const minutesEqual = time.getMinutes() === this._obj.getMinutes();
  const secondsEqual = time.getSeconds() === this._obj.getSeconds();
  const millisecondsEqual =
    time.getMilliseconds() === this._obj.getMilliseconds();

  return this.assert(
    hoursEqual && minutesEqual && secondsEqual && millisecondsEqual,
    `expected ${this._obj} to equal ${time}`,
    `expected ${this._obj} to not equal ${time}`,
    expected,
    actual
  );
});

Assertion.addMethod("equalDate", function(this: any, date: Date) {
  const expected = date.toDateString();
  const actual = this._obj.toDateString();

  return this.assert(
    expected === actual,
    `expected ${actual} to equal ${expected}`,
    `expected ${actual} to not equal ${expected}`,
    expected,
    actual
  );
});
