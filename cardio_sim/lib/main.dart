import 'package:cardio_sim/common/styles/sizes.dart';
import 'package:cardio_sim/common/utils/snack_bar_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'common/go_router/go_router.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(ProviderScope(
    child: ScreenUtilInit(
      designSize: const Size(1920, 1080),
      rebuildFactor: RebuildFactors.always,
      builder: (context, child) => const CardioSim(),
    ),
  ));
}

class CardioSim extends ConsumerWidget {
  const CardioSim({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ResponsiveData.kIsMobile = MediaQuery.of(context).size.width <= kMobileTrigger;
    final route = ref.watch(routerProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false, // 디버그 표시 지우기
      scaffoldMessengerKey: SnackBarUtil.key,
      title: 'Cardio Sim',
      routerConfig: route,
    );
  }
}
