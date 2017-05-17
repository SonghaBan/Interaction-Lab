void setup() {
  Serial.begin(9600);
}

void loop() {
  int sensor1 = analogRead(A0);
  sensor1 = sensor1 * (100.0 / 1023.0);
  int sensor2 = analogRead(A1);
  sensor2 = sensor2 / 700;
  Serial.print(sensor1);
  Serial.print(",");  // put comma between sensor values
  Serial.print(sensor2);
  Serial.println(); // add linefeed after sending the last sensor value

  // too fast communication might cause some latency in Processing
  // this delay resolves the issue.
  delay(10);
}
