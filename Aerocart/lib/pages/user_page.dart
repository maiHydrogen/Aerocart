import 'package:amazon_clone/auth/auth_page.dart';
import 'package:amazon_clone/layout/screen_layout.dart';
import 'package:amazon_clone/pages/order_requests.dart';
import 'package:amazon_clone/pages/profile.dart';
import 'package:amazon_clone/pages/search_screen.dart';
import 'package:amazon_clone/pages/wishlist.dart';
import 'package:amazon_clone/pages/your_orders.dart';
import 'package:amazon_clone/utils/user_tile.dart';
import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/user_details_bar.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  Stream<QuerySnapshot<Map<String, dynamic>>>? userStream;

  @override
  void initState() {
    super.initState();
    userStream = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("orderRequests")
        .snapshots();
  }

  void signout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
      builder: (context) {
        return const AuthPage();
      },
    ), (route) => false);
  }

  final AsyncMemoizer<QuerySnapshot<Map<String, dynamic>>> memoizer =
      AsyncMemoizer();

  Future<QuerySnapshot<Map<String, dynamic>>> fetchData() {
    return memoizer.runOnce(() async {
      return await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("orders")
          .get();
    });
  }

  @override
  Widget build(BuildContext context) {
    final MQ=MediaQuery.of(context).size;
    double height = MQ.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, height / 11),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 168, 202, 127),
                Color.fromARGB(255, 37, 46, 42)
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(
                            builder: (context) {
                              return const ScreenLayout();
                            },
                          ), (route) => false);
                        },
                        child: Image.asset(
                          'lib/images/amazon.png',
                          height: 80,
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.notifications_none_outlined,
                              size: 28,
                              color: Color.fromARGB(255, 255, 253, 240),
                            )),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SearchScreen(),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.search,
                            size: 28,
                            color: Color.fromARGB(255, 255, 253, 240),
                          ),
                        ),
                      ],
                    ),
                  ]),
            ),
          ]),
        ),
      ),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16.0,
              left: 10.0,
              right: 10.0,
              bottom: 10.0,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 168, 202, 127),
                  Color.fromARGB(255, 37, 46, 42)
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              padding:
                  const EdgeInsets.only(left: 16, right: 16, top: 5, bottom: 5),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16.0),
                  bottomRight: Radius.circular(16.0),
                ),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: MQ.height * 0.08,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius:BorderRadius.all(Radius.circular(15)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 25,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Padding(padding: EdgeInsets.symmetric(vertical: MQ.height*0.023,horizontal: 20),
                      child: Text('Hello, User!', style: TextStyle(
                        fontSize:
                        MQ.width * 0.06,
                        color: Colors.black87,
                      )),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Column(children: [
                        const SizedBox(height: 5),
                        UserTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const UserProfile(),
                              ),
                            );
                          }, image: 'lib/images/profile5.jpg',
                          child: Text('Your Account',
                              style: TextStyle(
                                fontSize:
                                    MQ.width * 0.06,
                              )),
                        ),
                        const SizedBox(height: 15),
                        UserTile2(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const Wishlist(),
                              ),
                            );
                          },
                          image: 'lib/images/wis.webp',
                          child: Text('Wishlist',
                              style: TextStyle(
                                fontSize:
                                    MQ.width * 0.06,
                              )),
                        ),
                      ]),
                      const Spacer(),
                      Column(
                        children: [
                          const SizedBox(height: 5),
                          UserTile2(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const YourOrders(),
                                ),
                              );
                            },
                            image: 'lib/images/orders3.jpg',
                            child: Text('Your orders',
                                style: TextStyle(
                                  fontSize:
                                      MQ.width * 0.06,
                                )),
                          ),
                          const SizedBox(height: 15),
                          UserTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const OrderRequests(),
                                ),
                              );
                            },
                            image: 'lib/images/order-requests.png',
                            child: Column(
                              children: [
                                Text('Order',
                                    style: TextStyle(
                                      fontSize:
                                          MQ.width *
                                              0.06,
                                    )),
                                Text('Requests',
                                    style: TextStyle(
                                      fontSize:
                                          MQ.width *
                                              0.06,
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          UserDetailsBar(
            offset: 0,
          )
        ],
      ),
    );
  }
}
