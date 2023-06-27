import 'package:flutter/material.dart';
import 'package:instagram_clone/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MessageCard extends StatelessWidget {
  final String text;
  final String userPhotoUrl;
  final String senderPhotoUrl;
  final String? imageUrl;
  final bool owner;
  final date;
  final prevdate;
  const MessageCard(
      {super.key,
      required this.text,
      required this.userPhotoUrl,
      required this.senderPhotoUrl,
      required this.date,
      required this.owner,
      required this.prevdate,
      required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width,
      ),
      width: double.infinity,
      child: Column(
        children: [
          prevdate == null ||
                  (DateFormat.yMMMd().format(prevdate.toDate()) !=
                      DateFormat.yMMMd().format(date.toDate()))
              ? Container(
                  padding: const EdgeInsets.all(10),
                  margin: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 34, 33, 33),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    DateFormat.yMMMd().format(date.toDate()),
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                )
              : Container(),
          Row(
            mainAxisAlignment:
                owner ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!owner)
                CachedNetworkImage(
                  imageUrl: userPhotoUrl,
                  imageBuilder: ((context, imageProvider) => CircleAvatar(
                        backgroundImage: imageProvider,
                        radius: 16,
                      )),
                  placeholder: (context, url) => Container(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
              const SizedBox(
                width: 10,
              ),
              (imageUrl == null || imageUrl == '')
                  ? GestureDetector(
                      onLongPress: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return SimpleDialog(
                                children: [
                                  SimpleDialogOption(
                                    onPressed: () {},
                                    child: const Text('delete'),
                                  )
                                ],
                              );
                            });
                      },
                      child: Container(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              constraints: BoxConstraints(
                                maxWidth:
                                    MediaQuery.of(context).size.width - 80,
                              ),
                              decoration: BoxDecoration(
                                color: owner
                                    ? const Color.fromARGB(255, 34, 33, 33)
                                    : mobileBackgroundColor,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                    color: owner
                                        ? Colors.transparent
                                        : Colors.grey),
                              ),
                              child: Text(
                                text,
                                softWrap: true,
                                overflow: TextOverflow.clip,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                                maxLines: null,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              DateFormat.jm().format(
                                  DateTime.fromMillisecondsSinceEpoch(
                                      date.millisecondsSinceEpoch)),
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      ),
                    )
                  : Column(
                    crossAxisAlignment: owner ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: owner
                                ? const Color.fromARGB(255, 34, 33, 33)
                                : mobileBackgroundColor,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width - 110,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: CachedNetworkImage(
                                    imageUrl: imageUrl!,
                                    placeholder: (context, url) => Container(),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                              text != ''
                                  ? Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        text,
                                        softWrap: true,
                                        overflow: TextOverflow.clip,
                                        style: const TextStyle(
                                          fontSize: 18,
                                        ),
                                        maxLines: null,
                                      ),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text(
                          DateFormat.jm().format(
                              DateTime.fromMillisecondsSinceEpoch(
                                  date.millisecondsSinceEpoch)),
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
              const SizedBox(
                width: 10,
              ),
              if (owner)
                CachedNetworkImage(
                  imageUrl: senderPhotoUrl,
                  imageBuilder: ((context, imageProvider) => CircleAvatar(
                        backgroundImage: imageProvider,
                        radius: 16,
                      )),
                  placeholder: (context, url) => Container(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
