# Dự báo biến động tỷ giá USD/VND & Phân tích các yếu tố vĩ mô (2015 - 2025)

## Tổng quan dự án
Trong bối cảnh kinh tế toàn cầu nhiều biến động, tỷ giá hối đoái (USD/VND) là biến số vĩ mô trọng yếu ảnh hưởng trực tiếp đến lạm phát, dòng vốn FDI và cán cân thương mại của Việt Nam. Dự án này tập trung phân tích tác động của các yếu tố kinh tế vĩ mô đến tỷ giá USD/VND trong giai đoạn 2015 - 2025. Đồng thời, dự án xây dựng các mô hình chuỗi thời gian có khả năng giải thích hiệu ứng bất đối xứng và đuôi dày (fat tails) thường thấy trên thị trường ngoại hối, kết hợp thử nghiệm mô hình học sâu (LSTM) để đánh giá khả năng dự báo. Ngôn ngữ và công cụ sử dụng chính bao gồm STATA cho các mô hình kinh tế lượng (OLS, ARMA, ARMAX, GARCH, EGARCH, GED) và Python cho mạng nơ-ron hồi quy.

## Mục tiêu nghiên cứu
Dự án được thực hiện nhằm giải quyết ba mục tiêu cốt lõi. Thứ nhất, xác định các biến số vĩ mô có tác động mạnh và độ nhạy cao nhất đến sự biến động của tỷ giá USD/VND. Thứ hai, kiểm định giả thuyết thị trường ngoại hối Việt Nam có nhạy cảm thái quá với các cú sốc tiêu cực hay không (Asymmetric Volatility). Cuối cùng, đề xuất mô hình dự báo rủi ro biến động tối ưu nhằm hỗ trợ công tác hoạch định và quản trị rủi ro tỷ giá cho tổ chức.

## Dữ liệu và Biến số
Dữ liệu nghiên cứu được thu thập theo tần suất tuần, trải dài từ Tuần 1 năm 2015 đến Tuần 13 năm 2025 với tổng cộng 533 quan sát từ các nguồn uy tín như Investing, FRED và Trading Economics. 

Biến phụ thuộc được lựa chọn là Tỷ giá danh nghĩa USD/VND (EX_US_VN). Các yếu tố vĩ mô độc lập được đưa vào mô hình tối ưu bao gồm Lãi suất trái phiếu Chính phủ Việt Nam kỳ hạn 10 năm (VNGB), Lạm phát của Hoa Kỳ (CPI_US), Chỉ số chứng khoán S&P 500 (SPX), và Dự trữ ngoại hối của Việt Nam (VNFR).

## Phương pháp tiếp cận
Quy trình phân tích đi từ các bước cơ bản đến nâng cao để nhận diện chính xác cấu trúc chuỗi thời gian. Dữ liệu trước tiên được kiểm định tính dừng (ADF Test) và đa cộng tuyến. Tiếp theo, mô hình ARMAX(1,6) được sử dụng để lập mô hình giá trị trung bình và đo lường hướng tác động của các biến vĩ mô. Khi phát hiện hiệu ứng ARCH trong phần dư, dự án tiếp tục áp dụng mô hình GARCH(1,1) để giải thích cụm biến động, mở rộng sang EGARCH(1,1) để bắt hiệu ứng bất đối xứng, và sử dụng phân phối GED để xử lý triệt để đặc tính đuôi dày của chuỗi tài chính.

## Kết quả cốt lõi
**Động lực thúc đẩy tỷ giá:** Kết quả thực nghiệm chỉ ra Lãi suất VNGB có tác động cùng chiều; khi lãi suất tăng làm tăng chi phí vốn, dẫn đến áp lực nội tệ mất giá. Ngược lại, Dự trữ ngoại hối (VNFR) có tác động ngược chiều, cho thấy quỹ dự trữ dồi dào giúp Ngân hàng Nhà nước can thiệp hiệu quả và làm giảm áp lực biến động tỷ giá.

**Hiệu ứng bất đối xứng:** Mô hình EGARCH xác nhận thị trường ngoại hối Việt Nam có phản ứng mạnh mẽ và nhạy cảm hơn đối với các cú sốc âm (tin tức xấu, rủi ro) so với các tin tức tích cực có cùng cường độ.

**Mô hình tối ưu:** ARMAX(1,6)-EGARCH(1,1) kết hợp phân phối GED được chứng minh là mô hình phù hợp nhất để mô phỏng dữ liệu. Mô hình này đạt giá trị Log-likelihood cao nhất (2536.57), giải quyết triệt để hiện tượng tự tương quan phần dư và cho tỷ lệ dự báo đúng chiều biến động (Directional Accuracy) đạt 75%.

Bên cạnh đó, việc chạy thử nghiệm bổ sung thuật toán học sâu LSTM trên Python cho ra kết quả dự báo bám sát xu hướng thực tế với sai số (MAPE) dưới 0.4%, minh chứng cho tính ứng dụng cao của Machine Learning vào phân tích chuỗi dữ liệu tài chính.

![Biểu đồ dự báo USD/VND bằng mô hình LSTM]([images/lstm_chart.png])

## Cấu trúc Repository
```text
├── data/
│   ├── Data_week      # Dữ liệu vĩ mô (tỷ giá, lãi suất, lạm phát...)
│   └── Data_day
├── code/
│   ├── main.do                          # STATA Script: Chạy ARMAX, GARCH, EGARCH
│   └── lstm_prediction.ipynb            # Python Notebook: Chạy mô hình học sâu LSTM
├── lstm_chart.png                       # Hình ảnh biểu đồ kết quả
└── README.md                            # Tổng quan dự án
