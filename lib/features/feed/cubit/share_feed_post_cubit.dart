import 'package:bloc/bloc.dart';
import 'package:fluttercon/common/data/models/feed.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:share_plus/share_plus.dart';

part 'share_feed_post_state.dart';
part 'share_feed_post_cubit.freezed.dart';

class ShareFeedPostCubit extends Cubit<ShareFeedPostState> {
  ShareFeedPostCubit() : super(const ShareFeedPostState.initial());

  Future<void> sharePost(Feed feed) async {
    emit(const ShareFeedPostState.loading());
    try {
      // if (feed.image != null) {
      //   final files = await Misc.downloadFiles([feed.image!]);
      //   await Share.shareXFiles(
      //     files,
      //     text: '${feed.body}\n\nhttps://fluttercon.dev',
      //   );
      // } else {
      await Share.share('${feed.body}\n\nhttps://fluttercon.dev');
      // }
      emit(const ShareFeedPostState.loaded());
    } catch (e) {
      emit(ShareFeedPostState.error(e.toString()));
    }
  }
}
