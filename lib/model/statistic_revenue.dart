class StatisticsRevenue {
  double? totalRevenue;

  StatisticsRevenue({
    this.totalRevenue,
  });

  StatisticsRevenue.fromJson(Map<String, dynamic> json) {
    totalRevenue = json['totalRevenue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (totalRevenue != null) {
      data['totalRevenue'] = totalRevenue;
    }
    return data;
  }
}
