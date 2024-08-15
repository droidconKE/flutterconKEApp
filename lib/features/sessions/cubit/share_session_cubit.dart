import 'package:bloc/bloc.dart';
import 'package:fluttercon/common/data/models/models.dart';
import 'package:fluttercon/common/utils/misc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:share_plus/share_plus.dart';

part 'share_session_state.dart';
part 'share_session_cubit.freezed.dart';

class ShareSessionCubit extends Cubit<ShareSessionState> {
  ShareSessionCubit() : super(const ShareSessionState.initial());

  Future<void> shareSession(Session session) async {
    emit(const ShareSessionState.loading());
    try {
      if (session.sessionImage != null) {
        final files = await Misc.downloadFiles([session.sessionImage!]);
        await Share.shareXFiles(
          files,
          text: '${session.description}\n\nhttps://fluttercon.dev',
        );
      } else {
      await Share.share('${session.description}\n\nhttps://fluttercon.dev');
      }
      emit(const ShareSessionState.loaded());
    } catch (e) {
      emit(ShareSessionState.error(e.toString()));
    }
  }
}
