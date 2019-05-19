def create_area
  hanoi = ["Ba Đình", "Hoàn Kiếm", "Cầu Giấy", "Long Biên", "Đống Đa", "Hai Bà Trưng",
             "Hoàng Mai", "Thanh Xuân", "Hà Đông", "Nam Từ Liêm", "Bắc Từ Liêm", "Tây Hồ"]
  hcm = ["Quận 1", "Quận 12", "Quận Thủ Đức", "Quận 9", "Quận Gò Vấp", "Quận Bình Thạnh",
        "Quận Tân Bình", "Quận Tân Phú", "Quận Phú Nhuận", "Quận 2",
        "Quận 3", "Quận 4", "Quận 5", "Quận 6", "Quận 7", "Quận 8", "Quận Bình Tân", "Quận 10", "Quận 11"]
  hn = Area.create(name: "Hà Nội")
  hc = Area.create(name: "Hồ Chí Minh")

  hanoi.each do |area|
    Area.create(name: area, parent_id: hn.id)
  end
  hcm.each do |area|
    Area.create(name: area, parent_id: hc.id)
  end
end

create_area