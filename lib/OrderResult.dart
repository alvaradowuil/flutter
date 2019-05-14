class OrderResult{
  final bool result;
  final String message;

  OrderResult(this.result, this.message);

  isResult() => this.result;

  getMessage() => this.message;
}