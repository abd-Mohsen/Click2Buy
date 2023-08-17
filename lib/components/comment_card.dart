import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:test1/models/comment_model.dart';

import '../constants.dart';

class CommentCard extends StatelessWidget {
  final CommentModel comment;
  const CommentCard({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: ExpansionTile(
        //collapsedBackgroundColor: cs.surface.withOpacity(0),
        leading: Icon(Icons.person, color: cs.onSurface.withOpacity(0.7), size: 30),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(comment.userName, style: kTextStyle22Bold, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            comment.rating != null
                ? RatingBar.builder(
                    ignoreGestures: true,
                    initialRating: double.parse(comment.rating!),
                    glow: false,
                    itemSize: 14,
                    minRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 2.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      //
                    },
                  )
                : const SizedBox.shrink()
          ],
        ),
        // subtitle: Padding(
        //   padding: const EdgeInsets.only(top: 8.0, bottom: 16),
        //   child: Text(
        //     "Lorem ipsum dolor sit amet consectetur adipisicing elit. Voluptatem at dignissimos quaerat eum possimus "
        //     "architecto non distinctio. Voluptatibus, debitis placeat rem reiciendis assumenda modi in repellat ipsum, accusamus aliquid velit.",
        //     style: kTextStyle18.copyWith(color: cs.onSurface.withOpacity(0.7)),
        //   ),
        // ),
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 16, left: 8, right: 8),
            child: Text(
              comment.text,
              style: kTextStyle18.copyWith(color: cs.onSurface.withOpacity(0.7)),
            ),
          ),
        ],
      ),
    );
  }
}
