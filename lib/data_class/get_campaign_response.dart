class CampaignResponse {
  List<Campaign> campaignList;

  CampaignResponse({required this.campaignList});

  factory CampaignResponse.fromJson(Map<String, dynamic> json) {
    List<Campaign> list = [];

    if (json['data'] != null) {
      for (dynamic data in json['data']) {
        list.add(Campaign.fromJson(data));
      }
    }

    return CampaignResponse(campaignList: list);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['data'] = campaignList.map((v) => v.toJson()).toList();
    return data;
  }
}

class Campaign {
  int id;
  int productId;
  String picture;
  String story;

  Campaign({
    required this.id,
    required this.productId,
    required this.picture,
    required this.story,
  });

  factory Campaign.fromJson(Map<String, dynamic> json) {
    return Campaign(
      id: json['id'],
      productId: json['product_id'],
      picture: json['picture'],
      story: json['story'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['product_id'] = productId;
    data['picture'] = picture;
    data['story'] = story;
    return data;
  }
}
