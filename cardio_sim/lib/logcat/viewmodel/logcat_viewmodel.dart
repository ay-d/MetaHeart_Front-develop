import 'package:cardio_sim/auth/model/state/member_state.dart';
import 'package:cardio_sim/common/value_state/util/value_state_util.dart';
import 'package:cardio_sim/logcat/model/service/logcat_service.dart';
import 'package:cardio_sim/logcat/model/state/logcat_state.dart';
import 'package:cardio_sim/logcat/view/logcat_chart_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

final logcatViewmodelProvider = Provider((ref) => LogcatViewModel(ref));

class LogcatViewModel {
  Ref ref;

  late LogcatService _service;
  final MemberState _memberState = MemberState();
  LogcatState logcatState = LogcatState();

  LogcatViewModel(this.ref) {
    _service = ref.read(logcatServiceProvider);
  }

  void getInfo() {
    logcatState.withResponse(_service.getLogData());
  }

  void downloadFile(String name) async {
    if (await canLaunchUrl(Uri.parse(
        '${dotenv.get("S3_PATH")}/${_memberState.value!.s3Path}/$name'))) {
      await launchUrl(Uri.parse(
          '${dotenv.get("S3_PATH")}/${_memberState.value!.s3Path}/$name'));
    } else {
      print('Could not launch $name');
    }
  }

  void navigatePop(context) {
    GoRouter.of(context).go('/');
  }

  void navigateToLogcatChartView(BuildContext context) {
    context.pushNamed(LogcatChartView.name);
  }
}
