class JobObject {
  late int bookid;
  late String name;
  late String phn;
  late String pickupadress;
  late String dropaddress;
  late int passengers;
  late String luggage;
  late String paymentmethod;
  late String total_amount;
  late DateTime date;
  late String pickupnote;
  late String dropnote;
  late double plat;
  late double plong;
  late double dlat;
  late double dlong;
  late String distance;
  late String duration;
  late List<dynamic> stops;
  int status = 0;

  JobObject(
      this.bookid,
      this.name,
      this.phn,
      this.pickupadress,
      this.dropaddress,
      this.passengers,
      this.luggage,
      this.paymentmethod,
      this.total_amount,
      this.date,
      this.pickupnote,
      this.dropnote,
      this.plat,
      this.plong,
      this.dlat,
      this.dlong,
      this.distance,
      this.duration
      );

  String getMonth(int month) {
    switch (month) {
      case 1:
        return "Jan";
      case 2:
        return "Feb";
      case 3:
        return "Mar";
      case 4:
        return "Apr";
      case 5:
        return "May";
      case 6:
        return "June";
      case 7:
        return "July";
      case 8:
        return "Aug";
      case 9:
        return "Sept";
      case 10:
        return "Oct";
      case 11:
        return "Nov";
      case 12:
        return "Dec";
      default:
        throw "";
    }
  }
}
