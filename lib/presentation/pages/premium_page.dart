import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled/core/theme/app_pallete.dart';
import 'package:untitled/core/theme/button_large.dart';

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
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent, // Phần trên trong suốt
                    Colors.black.withOpacity(1), // Phần dưới tối dần
                  ],
                  stops: [0.6, 1.0], // Điều chỉnh vị trí chuyển đổi màu
                ).createShader(bounds);
              },
              blendMode:
                  BlendMode.darken, // Chế độ hòa trộn giúp ảnh tối mượt mà hơn
              child: Image.asset(
                "assets/image/pre_ima.jpg",
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width - 100,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
              child: SingleChildScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(children: [
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0),
                      Colors.black.withOpacity(1),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Column(
                    children: [
                      SizedBox(
                        height: initialSize - 50,
                      ),
                      Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  const Image(
                                    image: AssetImage(
                                        'assets/image/spotify_logo.png'),
                                    width: 30,
                                    height: 30,
                                  ),
                                  const SizedBox(
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
                              const SizedBox(
                                height: 20,
                              ),
                              Text(
                                'Nghe không giới hạn. Dùng thử Premium Individual trong 3 tháng với giá 50.000₫ trên Spotify.',
                                style: Pallete.textApp(fontSize: 20),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              ButtonLarge(
                                text: 'Dùng thử 3 tháng với 59.000₫',
                                style: Pallete.textApp(color: Colors.black),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Text.rich(TextSpan(
                                children: [
                                  const TextSpan(
                                      text:
                                          '50.000₫ cho 3 tháng, sau đó là 59.000₫/tháng. Chỉ áp dụng ưu đãi nếu bạn đăng ký qua Spotify và chưa từng dùng gói Premium. Các ưu đãi qua Google Play có thể khác.'),
                                  const TextSpan(
                                      text: 'Có thể áp dụng Điều khoản /n'),
                                  const TextSpan(
                                      text:
                                          'Ưu đãi kết thúc vào ngày 2 tháng 4, 2025')
                                ],
                                style: GoogleFonts.getFont('Montserrat',
                                    fontSize: 12,
                                    color: Colors.white60,
                                    fontWeight: FontWeight.w600),
                              )),
                              const SizedBox(height: 15,),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white12,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  children: [
                                    ListTile(
                                        title: Text(
                                      'Lý do nên dùng gói Premium',
                                      style: Pallete.textApp(fontSize: 17),
                                    )),
                                    const Divider(
                                      color: Colors.white12,
                                    ),
                                    ListTile(
                                      leading: const Icon(CupertinoIcons.shuffle),
                                      title: Text(
                                        'Phát nhạc theo thứ tự bất kỳ',
                                        style: Pallete.textApp(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.downloading_rounded),
                                      title: Text(
                                        'Tải xuống để nghe không cần mạng',
                                        style: Pallete.textApp(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.headphones_outlined),
                                      title: Text(
                                        'Chất lượng âm thanh cao',
                                        style: Pallete.textApp(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.people_outline),
                                      title: Text(
                                        'Nghe cùng bạn bè theo thời gian thực',
                                        style: Pallete.textApp(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    ListTile(
                                      leading: const Icon(CupertinoIcons.arrow_swap),
                                      title: Text(
                                        'Sắp xếp theo danh sách chờ',
                                        style: Pallete.textApp(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              Text(
                                'Các gói có sẵn',
                                style: Pallete.textApp(fontSize: 20),
                              ),
                              const SizedBox(
                                height: 25,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Colors.white12,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  children: [
                                    ListTile(
                                      title: Text(
                                        'Mini',
                                        style: Pallete.textApp(
                                            fontSize: 20,
                                            color: Colors.lightGreenAccent),
                                      ),
                                      subtitle: Text(
                                        '10.500₫ cho 1 tuần',
                                        style: Pallete.textApp(fontSize: 17),
                                      ),
                                    ),
                                    const Divider(
                                      color: Colors.white12,
                                      thickness: 2,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    const BulletPoint(
                                        text:
                                            '1 tài khoản Premium chỉ dành cho thiết bị'),
                                    const BulletPoint(
                                        text:
                                            'Nghe tối đa 30 bài hát trên 1 thiết bị khi không có kết nối mạng'),
                                    const BulletPoint(text: 'Thanh toán một lần'),
                                    const BulletPoint(
                                        text: 'Chất lượng âm thanh cơ bản'),
                                    const SizedBox(height: 20,),
                                    SizedBox(width: MediaQuery.of(context).size.width - 80,
                                      child:
                                      ButtonLarge(text: 'Mua Premium Mini', color: Colors.lightGreenAccent, style: Pallete.textApp(color: Colors.black),),),
                                    const SizedBox(height: 10,),
                                    GestureDetector(
                                      // onTap: () async {
                                      //   final Uri url = Uri.parse("https://example.com/terms");
                                      //   if (await canLaunchUrl(url)) {
                                      //     await launchUrl(url, mode: LaunchMode.externalApplication);
                                      //   } else {
                                      //     throw 'Không thể mở $url';
                                      //   }
                                      // },
                                      child: Text(
                                        "Điều khoản & Điều kiện",
                                        style: Pallete.textApp(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white60,
                                          decoration: TextDecoration.underline,
                                        ),
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

class BulletPoint extends StatelessWidget {
  final String text;

  const BulletPoint({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('•'),
          const SizedBox(
            width: 15,
          ),
          Expanded(
              child: Text(
            text,
            style: Pallete.textApp(fontSize: 15, fontWeight: FontWeight.w500),
          )),
          const SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}
