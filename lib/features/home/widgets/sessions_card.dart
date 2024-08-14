import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttercon/core/theme/theme_colors.dart';
import 'package:fluttercon/features/home/cubit/fetch_sessions_cubit.dart';

class SessionsCard extends StatefulWidget {
  const SessionsCard({super.key});

  @override
  State<SessionsCard> createState() => _SessionsCardState();
}

class _SessionsCardState extends State<SessionsCard> {
  @override
  void initState() {
    context.read<FetchSessionsCubit>().fetchSessions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      children: [
        Row(
          children: [
            const Text(
              'Sessions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: ThemeColors.blueColor,
                fontSize: 18,
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {},
              child: Row(
                children: [
                  const Text(
                    'View All',
                    style: TextStyle(
                      color: ThemeColors.blueColor,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: ThemeColors.blueColor.withOpacity(.11),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    child: BlocBuilder<FetchSessionsCubit, FetchSessionsState>(
                      builder: (context, state) => state.maybeWhen(
                        loaded: (_, extras) => Text('+ $extras'),
                        orElse: () => const SizedBox(
                          height: 16,
                          width: 16,
                          child: Padding(
                            padding: EdgeInsets.all(2),
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 250,
          child: BlocBuilder<FetchSessionsCubit, FetchSessionsState>(
            builder: (context, state) => state.maybeWhen(
              loaded: (sessions, _) => ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: sessions.length,
                itemBuilder: (context, index) {
                  final session = sessions[index];
                  return Container(
                    width: size.width * .7,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: ThemeColors.lightGrayColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            session.sessionImage,
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            session.title,
                            maxLines: 2,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            '@ 10:30 | Room 1',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              orElse: () => const Center(
                child: SizedBox(
                  height: 32,
                  width: 32,
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
