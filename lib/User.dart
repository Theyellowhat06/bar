class User{
  String id, ovog, ner, phone, address, bornDate, sex, amount, bank, rate, review, id2;
  /*
  1.deliver
  2.part_time
  3.taxi
  4.child
  5.child_care
  6.driver
  7.service
   */
  User(this.id, this.ovog, this.ner, this.phone, this.address, this.bornDate, this.sex, this.amount, this.bank, this.rate, this.review, this.id2);

  void update(String value, String title){
    switch (title){
      case "Төрсөн өдөр":
        this.bornDate = value;
        break;
      case "Утасны дугуур":
        this.phone = value;
        break;
      case "Хаяг":
        this.address = value;
        break;
      case "Дансны мэдээлэл":
        this.bank = value;
        break;
    }
  }
}