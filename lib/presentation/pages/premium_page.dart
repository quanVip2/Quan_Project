import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/core/theme/app_pallete.dart';

class PremiumPage extends StatefulWidget {
  const PremiumPage({super.key});

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return PremiumPageState();
  }
}

class PremiumPageState extends State<PremiumPage> {
  late ScrollController scrollController;
  double imageSize = 0;
  double initialSize = 240;
  double containerHeight = 500;
  double containerinitalHeight = 500;
  double imageOpacity = 1;
  bool showTopBar = false;

  @override
  void initState() {
    imageSize = initialSize;
    scrollController = ScrollController()
      ..addListener(() {
        imageSize = initialSize - scrollController.offset;
        if (imageSize < 0) {
          imageSize = 0;
        }
        containerHeight = containerinitalHeight - scrollController.offset;
        if (containerHeight < 0) {
          containerHeight = 0;
        }
        imageOpacity = imageSize / initialSize;
        if (scrollController.offset > 224) {
          showTopBar = true;
        } else {
          showTopBar = false;
        }
        print(scrollController.offset);
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: Stack(children: [
              /// Ảnh nền
              Column(
                children: [
                  Image.asset(
                    "assets/image/pre_ima.jpg",
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width - 200,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image(
                              image:
                                  AssetImage('assets/image/spotify_logo.png'),
                              width: 30,
                              height: 30,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Premium',
                              style: GoogleFonts.getFont('Montserrat',
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                        Text(
                          'Nghe không giới hạn. Dùng thử Premium Individual trong 3 tháng với giá 50.000₫ trên Spotify.',
                          style: GoogleFonts.getFont(
                            'Montserrat',
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),

              /// Lớp gradient đè lên ảnh
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width - 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.5),
                      Colors.black.withOpacity(1),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              const SizedBox(
                height: 100,
              )
            ]),
          ),
          SafeArea(
              child: SingleChildScrollView(
            controller: scrollController,
            physics: BouncingScrollPhysics(),
            child: Column(children: [
              Container(
                child: Padding(
                  padding: EdgeInsets.only(top: 40),
                  child: Column(
                    children: [
                      SizedBox(
                        height: initialSize + 100,
                      ),
                      Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Center(
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: ElevatedButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Dùng thử 3 tháng với giá 59.000₫',
                                      style: GoogleFonts.getFont('Montserrat',
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      padding: EdgeInsets.all(15),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(40),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text.rich(TextSpan(
                                children: [
                                  TextSpan(
                                      text:
                                          '50.000₫ cho 3 tháng, sau đó là 59.000₫/tháng. Chỉ áp dụng ưu đãi nếu bạn đăng ký qua Spotify và chưa từng dùng gói Premium. Các ưu đãi qua Google Play có thể khác.'),
                                  TextSpan(
                                      text: 'Có thể áp dụng Điều khoản /n'),
                                  TextSpan(
                                      text:
                                          'Ưu đãi kết thúc vào ngày 2 tháng 4, 2025')
                                ],
                                style: GoogleFonts.getFont('Montserrat',
                                    fontSize: 12,
                                    color: Colors.white60,
                                    fontWeight: FontWeight.w600),
                              )),
                              Container(
                                color: Colors.white12,
                                child: Column(
                                  children: [
                                    Text(
                                      'Lý do nên dùng gói Premium',
                                      style: Pallete.textApp(fontSize: 17),
                                    ),
                                    Divider(
                                      color: Colors.white12,
                                    ),
                                    ListTile(
                                      leading: Icon(CupertinoIcons.shuffle),
                                      title: Text(
                                        'Phát nhạc theo thứ tự bất kỳ',
                                        style: Pallete.textApp(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.downloading_rounded),
                                      title: Text(
                                        'Tải xuống để nghe không cần mạng',
                                        style: Pallete.textApp(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.headphones_outlined),
                                      title: Text(
                                        'Chất lượng âm thanh cao',
                                        style: Pallete.textApp(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    ListTile(
                                      leading: Icon(Icons.people_outline),
                                      title: Text(
                                        'Nghe cùng bạn bè theo thời gian thực',
                                        style: Pallete.textApp(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    ListTile(
                                      leading: Icon(CupertinoIcons.arrow_swap),
                                      title: Text(
                                        'Sắp xếp theo danh sách chờ',
                                        style: Pallete.textApp(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ))
                    ],
                  ),
                ),
              )
            ]),
          ))
        ],
      ),
    );
  }
}
