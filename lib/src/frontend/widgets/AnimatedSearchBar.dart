import 'package:chathub/src/controller/bloc/searchbloc.dart';
import 'package:chathub/src/controller/styles/baseStyle.dart';
import 'package:chathub/src/controller/styles/colorsStyle.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnimatedSearchBar extends StatefulWidget implements PreferredSizeWidget {
  @override
  _AnimatedSearchBarState createState() => _AnimatedSearchBarState();
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight + 20);
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar> {
  TextEditingController query = TextEditingController();
  FocusNode myFocusNode;
  @override
  void initState() {
    super.initState();
    myFocusNode = FocusNode();
    myFocusNode.requestFocus();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var searchBloc = Provider.of<SearchBloc>(context);
    return StreamBuilder<bool>(
        stream: searchBloc.foldSearchBar,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          bool _folded = snapshot.data;
          return AnimatedContainer(
            duration: Duration(milliseconds:400 ),
            margin: EdgeInsets.symmetric(horizontal: 3, vertical: 1.5),
            width: _folded ? 56 : MediaQuery.of(context).size.width / 1.1,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(BaseStyle.borderRaduis),
              color: AppColor.blackColor,
              boxShadow: BaseStyle.boxShadow,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                      padding: EdgeInsets.only(left: 16),
                      child: TextField(
                        style: TextStyle(color: Colors.white),
                        cursorColor: Colors.white,
                        focusNode: myFocusNode,
                        controller: query,
                        onChanged: (value) {
                          if (value.isEmpty) {
                            searchBloc.changeShowSearchResult(false);
                          } else {
                            searchBloc.changeShowSearchResult(true);
                            searchBloc.changeQuery(value.toLowerCase().trim());
                          }
                        },
                        decoration: InputDecoration(
                            hintText: 'Search...',
                            hintStyle: TextStyle(
                                letterSpacing: 1.5, color: Colors.white),
                            border: InputBorder.none),
                      )),
                ),
                Container(
                  child: Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(_folded ? 32 : 0),
                        topRight: Radius.circular(32),
                        bottomLeft: Radius.circular(_folded ? 32 : 0),
                        bottomRight: Radius.circular(32),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Icon(
                          Icons.close,
                          color: AppColor.iconColors,
                          size: BaseStyle.iconSize,
                        ),
                      ),
                      onTap: () {
                        searchBloc.changeFoldSearchBar(true);
                        searchBloc.changeShowSearchResult(false);
                      },
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}
