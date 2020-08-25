class Worker{
  String ovog, ner, phone, address, bornDate, sex, rate, review, edu, skill, dsc, usrId, type;
  int dest;
  double lat, lng;

  Worker(this.ovog, this.ner, this.phone, this.address, this.bornDate, this.sex, this.rate, this.review, this.edu, this.skill, this.dsc, this.usrId, this.dest, this.type);

  void update(Worker _worker){
    ovog = _worker.ovog;
    ner = _worker.ner;
    phone = _worker.phone;
    address = _worker.address;
    bornDate = _worker.bornDate;
    sex = _worker.sex;
    rate = _worker.rate;
    review = _worker.review;
    edu = _worker.edu;
    skill = _worker.skill;
    dsc = _worker.dsc;
    usrId = _worker.usrId;
    type = _worker.type;
    dest = _worker.dest;
  }

  void setLatLng(double _lat, double _lng){
    lat = _lat;
    lng = _lng;
  }
}