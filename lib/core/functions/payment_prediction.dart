List<double> paymentPrediction(double bill) {
  List<double> fragment = [
    100000,
    50000,
    20000,
    10000,
    5000,
    2000,
    1000,
    500,
    200,
    100,
    50
  ];
  List<double> pred = [];
  // pred.add(bill);

  for (int idx = 0; idx < fragment.length; idx++) {
    double mod = bill % fragment[idx];
    if (mod < bill) {
      double rslt = ((bill / fragment[idx]).ceil()) * fragment[idx];
      if (rslt != bill) {
        pred.add(rslt);
      }
    } else {
      pred.add(fragment[idx]);
    }
  }

  return pred.toSet().toList();
}
