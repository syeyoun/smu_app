// tabs/tab_home.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_1/models/model_item_provider.dart';
import 'package:test_1/models/model_time.dart';
import 'package:test_1/models/model_tabstate.dart';
import 'package:test_1/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:rxdart/rxdart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';


class TabLock extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: TabBar(
          labelColor: Colors.white,
          unselectedLabelColor: Color(0xff0E207F),
          indicator: BoxDecoration(
            color: Color(0xff0E207F),
          ),
          tabs: [
            Tab(text: '공지 게시판'),
            Tab(text: '자유 게시판'),
          ],
        ),
        body: TabBarView(
          children: [
            PostList(boardName: 'board1'), // 첫 번째 게시판
            PostList1(boardName: 'board2'), // 두 번째 게시판
          ],
        ),
      ),
    );
  }
}

class AddPost extends StatefulWidget {
  @override
  _AddPostState createState() => _AddPostState();
}

class _AddPostState extends State<AddPost> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  void addPost(String title, String content) async {
    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('제목과 내용을 모두 작성해주세요.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // 현재 로그인된 사용자 가져오기
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // 사용자 정보 가져오기
      Map<String, dynamic>? userInfo = await _getUserInfo(user.uid);

      if (userInfo != null && userInfo['role'] == 'admin') {
        DateTime now = DateTime.now();

        // 작성자 정보와 게시물 정보를 Firestore에 추가
        await FirebaseFirestore.instance.collection('board').add({
          'title': title,
          'content': content,
          'createdAt': now,
          'authorId': userInfo['username'], // 작성자의 username 추가
        }).then((value) {
          titleController.clear();
          contentController.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('게시물이 성공적으로 추가되었습니다.'),
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.pop(context);
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('게시물 추가 중 오류 발생: $error'),
              duration: Duration(seconds: 2),
            ),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('권한이 없습니다.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('사용자가 로그인되어 있지 않습니다.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // 사용자 정보 가져오는 함수
  Future<Map<String, dynamic>?> _getUserInfo(String userId) async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    // 사용자 정보가 존재하지 않을 경우 null 반환
    return userSnapshot.exists ? userSnapshot.data() as Map<String, dynamic> : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0E207F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: '제목'),
            ),
            TextField(
              controller: contentController,
              decoration: InputDecoration(labelText: '내용'),
              maxLines: null,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                addPost(titleController.text, contentController.text);
              },
              style: ElevatedButton.styleFrom(primary: Color(0xff0E207F)),
              child: Text('게시물 추가'),
            ),
          ],
        ),
      ),
    );
  }
}

class AddPost1 extends StatefulWidget {
  @override
  _AddPostState1 createState() => _AddPostState1();
}

class _AddPostState1 extends State<AddPost1> {
  final titleController1 = TextEditingController();
  final contentController1 = TextEditingController();

  void addPost1(String title, String content) async {
    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('제목과 내용을 모두 작성해주세요.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // 현재 로그인된 사용자 가져오기
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // 사용자 정보 가져오기
      Map<String, dynamic>? userInfo = await _getUserInfo(user.uid);

      if (userInfo != null) {
        DateTime now = DateTime.now();

        // 작성자 정보와 게시물 정보를 Firestore에 추가
        await FirebaseFirestore.instance.collection('board1').add({
          'title': title,
          'content': content,
          'createdAt': now,
          'authorId': user.uid,
          'author': userInfo['username'], // 작성자의 username 추가
          'likes': [],
        }).then((value) {
          titleController1.clear();
          contentController1.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('게시물이 성공적으로 추가되었습니다.'),
              duration: Duration(seconds: 2),
            ),
          );
          Navigator.pop(context);
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('게시물 추가 중 오류 발생: $error'),
              duration: Duration(seconds: 2),
            ),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('사용자 정보를 가져오는 데 실패했습니다.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('사용자가 로그인되어 있지 않습니다.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // 사용자 정보 가져오는 함수
  Future<Map<String, dynamic>?> _getUserInfo(String userId) async {
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    // 사용자 정보가 존재하지 않을 경우 null 반환
    return userSnapshot.exists ? userSnapshot.data() as Map<String, dynamic> : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0E207F),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController1,
              decoration: InputDecoration(labelText: '제목'),
            ),
            TextField(
              controller: contentController1,
              decoration: InputDecoration(labelText: '내용'),
              maxLines: null,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                addPost1(titleController1.text, contentController1.text);
              },
              style: ElevatedButton.styleFrom(primary: Color(0xff0E207F)),
              child: Text('게시물 추가'),
            ),
          ],
        ),
      ),
    );
  }
}

class PostList extends StatelessWidget {
  final String boardName;

  PostList({required this.boardName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: _getCombinedStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (!snapshot.hasData &&
              snapshot.data?[0]?.docs.isEmpty == true &&
              snapshot.data?[1]?.docs.isEmpty == true) {
            return Text('게시물이 없습니다');
          }

          final noticePosts = snapshot.data?[0]?.docs;
          final anotherPosts = snapshot.data?[1]?.docs;

          List<Widget> postWidgets = [];

          for (var postDocument in anotherPosts!) {
            final postTitle = postDocument['title'];
            final postContent = postDocument['content'];
            final postAuthorId = postDocument['authorId'];
            final createdAt = postDocument['createdAt'] as Timestamp;
            final formattedDate = '${createdAt.toDate().year}-${_twoDigits(createdAt.toDate().month)}-${_twoDigits(createdAt.toDate().day)}';

            postWidgets.add(
              Card(
                child: ListTile(
                  title: Text(postTitle),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Text(postContent),
                      SizedBox(height: 4),
                      //Text('$postAuthorId'),
                      Text('작성일       $formattedDate'), // 시간 표시
                    ],
                  ),
                ),
              ),
            );
          }

          for (var postDocument in noticePosts!) {
            final postArray = postDocument['noticeArray'] as List<dynamic>;

            for (var post in postArray) {
              final postTitle = post['title'].trim();
              final postContent = post['link'];
              final postDate = post['date'].toString().replaceAll('\n', '').trim();

              postWidgets.add(
                Card(
                  child: InkWell(
                    onTap: () async {
                      try {
                        await FlutterWebBrowser.openWebPage(url: postContent);
                      } catch (e) {
                        throw 'Could not launch $postContent';
                      }
                    },
                    child: ListTile(
                      title: Text(postTitle),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4),
                          Text(postContent),
                          SizedBox(height: 4),
                          Text(postDate),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          }

          return ListView(
            children: postWidgets,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddPost(),
                          ),
                        );
                      },
                      child: Text('게시물 추가'),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff0E207F),
                      ),
                    ),
                    SizedBox(height: 4),
                    ElevatedButton(
                      onPressed: () async {
                        String link = "https://grad.smu.ac.kr/grad/department/introduction42.do";
                        try {
                          await FlutterWebBrowser.openWebPage(url: link);
                        } catch (e) {
                          throw 'Could not launch $link';
                        }
                        Navigator.pop(context);
                      },
                      child: Text('대학원 정보'),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff0E207F),
                      ),
                    ),
                    SizedBox(height: 4),
                    ElevatedButton(
                      onPressed: () async {
                        String link = "https://open.kakao.com/o/g4rjC8We";
                        try {
                          await FlutterWebBrowser.openWebPage(url: link);
                        } catch (e) {
                          throw 'Could not launch $link';
                        }
                        Navigator.pop(context);
                      },
                      child: Text('2학년 채팅방'),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff0E207F),
                      ),
                    ),
                    SizedBox(height: 4),
                    ElevatedButton(
                      onPressed: () async {
                        String link = "https://open.kakao.com/o/giz4G8We";
                        try {
                          await FlutterWebBrowser.openWebPage(url: link);
                        } catch (e) {
                          throw 'Could not launch $link';
                        }
                        Navigator.pop(context);
                      },
                      child: Text('3학년 채팅방'),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff0E207F),
                      ),
                    ),
                    SizedBox(height: 4),
                    ElevatedButton(
                      onPressed: () async {
                        String link = "https://open.kakao.com/o/ga6QI8We";
                        try {
                          await FlutterWebBrowser.openWebPage(url: link);
                        } catch (e) {
                          throw 'Could not launch $link';
                        }
                        Navigator.pop(context);
                      },
                      child: Text('4학년 채팅방'),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff0E207F),
                      ),
                    ),
                    SizedBox(height: 4)
                  ],
                ),
              );
            },
          );
        },
        backgroundColor: Color(0xff0E207F),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Stream<List<QuerySnapshot>> _getCombinedStream() {
    Stream<QuerySnapshot> noticeStream = FirebaseFirestore.instance.collection('notice').snapshots();
    Stream<QuerySnapshot> anotherStream = FirebaseFirestore.instance.collection('board').orderBy('createdAt', descending: true).snapshots();

    return Rx.combineLatest2(noticeStream, anotherStream, (a, b) => [a, b]);
  }

  String _twoDigits(int n) {
    if (n >= 10) {
      return '$n';
    } else {
      return '0$n';
    }
  }
}

class PostList1 extends StatelessWidget {
  final String boardName;

  PostList1({required this.boardName});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('board1')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }

          if (snapshot.hasData) {
            final posts = snapshot.data?.docs;

            if (posts != null && posts.isNotEmpty) {
              List<Widget> postWidgets = [];
              for (var post in posts) {
                final documentId = post.id;
                final postData = post.data() as Map<String, dynamic>;
                final postTitle = post['title'];
                final postContent = post['content'];
                final postAuthor = post['author'];
                final postAuthorId = post['authorId'];
                final createdAt = post['createdAt'] as Timestamp;
                final formattedDate = '${createdAt.toDate().year}-${_twoDigits(createdAt.toDate().month)}-${_twoDigits(createdAt.toDate().day)} ${_twoDigits(createdAt.toDate().hour)}:${_twoDigits(createdAt.toDate().minute)}';

                postWidgets.add(
                  Card(
                    child: ListTile(
                      title: Text(postTitle),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 4),
                          //Text(postContent),
                          //SizedBox(height: 4),
                          Text('$postAuthor'),
                          Text('$formattedDate'), // 시간 표시
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PostDetailPage(
                              documentId: documentId,
                              title: postTitle,
                              content: postContent,
                              author: postAuthor,
                              authorId: postAuthorId,
                              formattedDate: formattedDate,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                );
              }

              return ListView(
                children: postWidgets,
              );
            } else {
              return Text('게시물이 없습니다');
            }
          } else {
            return Text('로딩 중...');
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return Container(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddPost1(),
                          ),
                        );
                      },
                      child: Text('게시물 추가'),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff0E207F),
                      ),
                    ),
                    SizedBox(height: 4),
                    ElevatedButton(
                      onPressed: () async {
                        //
                      },
                      child: Text('게시물 검색'),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff0E207F),
                      ),
                    ),
                    SizedBox(height: 4),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudyListPage(),
                          ),
                        );
                      },
                      child: Text('스터디 모집'),
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff0E207F),
                      ),
                    ),
                    SizedBox(height: 4)
                  ],
                ),
              );
            },
          );
        },
        backgroundColor: Color(0xff0E207F),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  String _twoDigits(int n) {
    if (n >= 10) {
      return '$n';
    } else {
      return '0$n';
    }
  }
}

class PostDetailPage extends StatelessWidget {
  final String documentId;
  final String title;
  final String content;
  final String author;
  final String authorId;
  final String formattedDate;

  PostDetailPage({
    required this.documentId,
    required this.title,
    required this.content,
    required this.author,
    required this.authorId,
    required this.formattedDate,
  });

  void _toggleLike(String documentId, String userId) async {
    try {
      DocumentReference postRef =
      FirebaseFirestore.instance.collection('board1').doc(documentId);

      DocumentSnapshot postSnapshot = await postRef.get();
      Map<String, dynamic> postData = postSnapshot.data() as Map<String, dynamic>;
      List<String> likes = List<String>.from(postData['likes'] ?? []);

      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        if (likes.contains(user.uid)) {
          // 사용자가 이미 게시물에 좋아요를 눌렀으면 좋아요를 취소합니다.
          likes.remove(user.uid);
        } else {
          // 사용자가 아직 게시물에 좋아요를 누르지 않았으면 좋아요를 추가합니다.
          likes.add(user.uid);
        }

        await postRef.update({'likes': likes});
      }
    } catch (error) {
      print('좋아요 토글 중 오류 발생: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0E207F),
        actions: [
          if (user != null && user.uid == authorId)
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditPostPage(
                      documentId: documentId,
                      title: title,
                      content: content,
                      authorId: authorId,
                    ),
                  ),
                );
              },
              child: Text('편집'),
              style: ElevatedButton.styleFrom(
                primary: Color(0xff0E207F),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('작성자: $author      작성일: $formattedDate'),
            SizedBox(height: 8),
            Text(
              content,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            StreamBuilder(
              // 게시물 데이터를 가져오기 위한 StreamBuilder 추가
              stream: FirebaseFirestore.instance.collection('board1').doc(documentId).snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }

                if (!snapshot.hasData || snapshot.data == null) {
                  return Text('게시물을 불러오는 중에 오류가 발생했습니다.');
                }

                // 수정된 부분: snapshot.data에서 게시물 데이터를 가져옴
                Map<String, dynamic> post = (snapshot.data?.data() as Map<String, dynamic>) ?? {};
                User? user = FirebaseAuth.instance.currentUser;

                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.thumb_up),
                      color: post['likes'] != null &&
                          post['likes'].contains(user?.uid)
                          ? Color(0xff0E207F)
                          : null,
                      onPressed: () {
                        User? user = FirebaseAuth.instance.currentUser;
                        if (user != null) {
                          _toggleLike(documentId, user.uid);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('로그인이 필요합니다.'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                    ),
                    Text('${post['likes']?.length ?? 0}'),
                    //SizedBox(height: 16),
                    // 댓글 목록 표시
                    //CommentList(postId: documentId),
                    //SizedBox(height: 16),
                    // 댓글 작성 폼 표시
                    //AddCommentForm(postId: documentId),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class EditPostPage extends StatefulWidget {
  final String documentId;
  final String title;
  final String content;
  final String authorId;

  EditPostPage({
    required this.documentId,
    required this.title,
    required this.content,
    required this.authorId,
  });

  @override
  _EditPostPageState createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  User? user;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _contentController = TextEditingController(text: widget.content);
    user = FirebaseAuth.instance.currentUser;
  }

  void _deletePost(BuildContext context, String documentId, String authorId) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null && user.uid == authorId) {
        await FirebaseFirestore.instance.collection('board1').doc(documentId).delete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('게시물이 성공적으로 삭제되었습니다.'),
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('해당 사용자는 삭제 권한이 없습니다.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('게시물 삭제 중 오류 발생: $error'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff0E207F),
        title: Text('게시물 편집'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: '제목'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: '내용'),
              maxLines: null, // 내용에 여러 줄 허용
            ),
            SizedBox(height: 16),
            Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _saveEditedPost(context);
                  },
                  child: Text('게시물 저장'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff0E207F),
                  ),
                ),
                SizedBox(height: 4),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    _deletePost(context, widget.documentId, widget.authorId);
                  },
                  child: Text('게시물 삭제'),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xff0E207F),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _saveEditedPost(BuildContext context) async {
    // 편집된 게시물을 저장하는 로직을 구현합니다.
    try {
      if (_titleController.text.isEmpty|| _contentController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('제목과 내용을 모두 작성해주세요.'),
            duration: Duration(seconds: 2),
          ),
        );
        return;
      }
      // 작성자 확인 추가
      if (user != null && user!.uid == widget.authorId) {
        await FirebaseFirestore.instance.collection('board1').doc(widget.documentId).update({
          'title': _titleController.text,
          'content': _contentController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('게시물이 성공적으로 수정되었습니다.'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context);
        Navigator.pop(context); // PostDetailPage로 돌아갑니다.
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('해당 사용자는 수정 권한이 없습니다.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('게시물 수정 중 오류 발생: $error'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}


class Study {
  final String id;
  final String title;
  final String description;
  final int recruitmentLimit;
  final List<String> members;
  final DateTime recruitmentDate;

  Study({
    required this.id,
    required this.title,
    required this.description,
    required this.recruitmentLimit,
    required this.members,
    required this.recruitmentDate,
  });

  factory Study.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Study(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      recruitmentLimit: data['recruitmentLimit'] ?? 0,
      members: List.from(data['members'] ?? []),
      recruitmentDate: (data['recruitmentDate'] as Timestamp).toDate(),
    );
  }
}

class StudyListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseFirestore.instance.collection('studies').orderBy('recruitmentDate').get(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<Study> studies = snapshot.data!.docs.map((doc) => Study.fromFirestore(doc)).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('스터디 목록'),
            ),
            body: ListView.builder(
              itemCount: studies.length,
              itemBuilder: (context, index) {
                Study study = studies[index];
                return ListTile(
                  title: Text(study.title),
                  subtitle: Text(study.description),
                  trailing: Text('모집 인원: ${study.recruitmentLimit} | 모집 날짜: ${study.recruitmentDate.toString()}'),
                  onTap: () {
                    // 스터디 상세 정보 페이지로 이동하는 로직 추가
                    // 예: Navigator.push(context, MaterialPageRoute(builder: (context) => StudyDetailPage(study: study)));
                  },
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                // 스터디 생성 페이지로 이동하는 로직 추가
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateStudyPage()),
                );
              },
              child: Icon(Icons.add),
            ),
          );
        }
      },
    );
  }
}

class CreateStudyPage extends StatefulWidget {
  @override
  _CreateStudyPageState createState() => _CreateStudyPageState();
}

class _CreateStudyPageState extends State<CreateStudyPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController recruitmentLimitController = TextEditingController();
  DateTime selectedDate = DateTime.now(); // 모집 날짜 추가

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    ))!;
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('스터디 생성'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: '스터디 제목'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: '스터디 설명'),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: recruitmentLimitController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: '모집 인원'),
            ),
            SizedBox(height: 16.0),
            Row(
              children: [
                Text('모집 날짜: ${selectedDate.toLocal()}'),
                SizedBox(width: 20.0),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: Text('날짜 선택'),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                String title = titleController.text;
                String description = descriptionController.text;
                int recruitmentLimit = int.parse(recruitmentLimitController.text);
                List<String> members = [];

                await FirebaseFirestore.instance.collection('studies').add({
                  'title': title,
                  'description': description,
                  'recruitmentLimit': recruitmentLimit,
                  'members': members,
                  'recruitmentDate': selectedDate, // 모집 날짜 추가
                });
                Navigator.pop(context);
                // 여기에서 생성한 스터디 데이터를 다음 페이지로 전달하거나 저장할 수 있음
              },
              child: Text('스터디 생성'),
            ),
          ],
        ),
      ),
    );
  }
}


















class Comment {
  final String id;
  final String contents;
  final String author; // 추가된 부분
  final DateTime createdAt;

  Comment({
    required this.id,
    required this.contents,
    required this.author,
    required this.createdAt,
  });
}


class CommentList extends StatelessWidget {
  final String postId;

  CommentList({required this.postId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('comments')
          .where('postId', isEqualTo: postId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return Text('댓글을 불러오는 중에 오류가 발생했습니다.');
        }

        List<Map<String, dynamic>> comments = (snapshot.data?.docs ?? [])
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();

        List<Comment> commentObjects = comments.map((comment) {
          return Comment(
            id: comment['id'],
            contents: comment['contents'], // 'contents' 사용
            author: comment['author'],
            createdAt: (comment['createdAt'] as Timestamp).toDate(),
          );
        }).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('댓글 목록:'),
            Expanded(
              child: Container(
                child: ListView.builder(
                  itemCount: commentObjects.length,
                  itemBuilder: (context, index) {
                    var comment = commentObjects[index];
                    return ListTile(
                      title: Text(comment.contents), // 'contents' 사용
                      subtitle: Text('작성자: ${comment.author}'),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class AddCommentForm extends StatefulWidget {
  final String postId;

  AddCommentForm({required this.postId});

  @override
  _AddCommentFormState createState() => _AddCommentFormState();
}

class _AddCommentFormState extends State<AddCommentForm> {
  final TextEditingController _commentController = TextEditingController();

  void _addComment() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        String content = _commentController.text.trim();

        if (content.isNotEmpty) {
          await FirebaseFirestore.instance.collection('comments').add({
            'postId': widget.postId,
            'contents': content, // 'contents' 사용
            'author': user.displayName ?? user.email ?? 'Anonymous',
            'createdAt': FieldValue.serverTimestamp(),
          });

          // 댓글 작성 후 텍스트 필드 비우기
          _commentController.clear();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('로그인이 필요합니다.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      print('댓글 작성 중 오류 발생: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _commentController,
          decoration: InputDecoration(
            hintText: '댓글을 입력하세요...',
          ),
        ),
        SizedBox(height: 8),
        ElevatedButton(
          onPressed: _addComment,
          child: Text('댓글 작성'),
        ),
      ],
    );
  }
}