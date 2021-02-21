import 'package:cached_network_image/cached_network_image.dart';
import 'package:delivery_service/data/models/favorite_model.dart';
import 'package:delivery_service/data/models/promo_model.dart';
import 'package:delivery_service/localization/localization_keys.dart';
import 'package:delivery_service/pages/base/base_bloc.dart';
import 'package:delivery_service/pages/base/base_page_state.dart';
import 'package:delivery_service/services/registry_service.dart';
import 'package:delivery_service/theme/branding_colors.dart';
import 'package:delivery_service/theme/insets.dart';
import 'package:delivery_service/theme/radiuses.dart';
import 'package:delivery_service/widgets/horizontal_shimmer_swipe_lane.dart';
import 'package:delivery_service/widgets/horizontal_swipe_lane.dart';
import 'package:delivery_service/widgets/shimmer_content.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:shimmer/shimmer.dart';

import 'home_bloc.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends BasePageState<HomeBloc, HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, BaseState>(
      cubit: bloc,
      builder: (_, state) {
        return Scaffold(
          backgroundColor: BrandingColors.background,
          appBar: AppBar(
            title: Text(
              translate(LocalizationKeys.Home_Title),
              style: textTheme.headline4,
            ),
          ),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(BaseState state) => SafeArea(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: _getSliverFromState(state),
        ),
      );

  List<Widget> _getSliverFromState(BaseState state) {
    if (state is InitialState) {
      return _getShimmerSlivers();
    } else {
      return _getContentSlivers();
    }
  }

  List<Widget> _getShimmerSlivers() => [
        _buildShimmerSectionTitle(),
        _buildShimmerLaneWithTitle(),
        _buildShimmerSectionTitle(isNeedTopSpacing: true),
        _buildShimmerLaneWithTitle(),
        _buildShimmerSectionTitle(isNeedTopSpacing: true),
        _buildShimmerList(),
        _buildBottomSpacingSliver(),
      ];

  List<Widget> _getContentSlivers() => [
        if (bloc.promosList.isNotEmpty)
          _buildSectionTitle(
            title: translate(LocalizationKeys.Home_Section_Promo),
          ),
        if (bloc.promosList.isNotEmpty) _buildPromoLane(),
        if (bloc.favoritesList.isNotEmpty)
          _buildSectionTitle(
            title: translate(LocalizationKeys.Home_Section_Favorites),
            isNeedTopSpacing: true,
          ),
        if (bloc.favoritesList.isNotEmpty) _buildFavoritesLane(),
        if (bloc.restaurantsList.isNotEmpty)
          _buildSectionTitle(
            title: translate(LocalizationKeys.Home_Section_Restaurants),
            isNeedTopSpacing: true,
          ),
        if (bloc.restaurantsList.isNotEmpty) _buildRestaurantsList(),
        _buildBottomSpacingSliver(),
      ];

  Widget _buildSectionTitle({
    String title,
    bool isNeedTopSpacing = false,
  }) =>
      SliverToBoxAdapter(
        child: Column(
          children: [
            if (isNeedTopSpacing) SizedBox(height: Insets.x5),
            SizedBox(
              height: Insets.x5,
              child: FractionallySizedBox(
                widthFactor: 0.90,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    style: textTheme.headline6,
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildPromoLane() => SliverToBoxAdapter(
        child: HorizontalSwipeLane<PromoModel>(
          items: bloc.promosList,
          childWidgetBuilder: (context, model) {
            return Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: model.imageUrl,
                    fadeOutDuration: Duration(),
                    placeholder: (context, url) => Icon(
                      Icons.image,
                      color: Colors.grey[100],
                      size: Insets.x25,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.0, 0.3, 1],
                      colors: [
                        Colors.grey[800].withOpacity(0.45),
                        Colors.grey[800].withOpacity(0.2),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: Insets.x4_5,
                  left: Insets.x4_5,
                  child: Text(
                    model.title,
                    style: textTheme.headline3.copyWith(
                      color: BrandingColors.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );

  Widget _buildFavoritesLane() => SliverToBoxAdapter(
        child: HorizontalSwipeLane<FavoriteModel>(
          items: bloc.favoritesList,
          childWidgetBuilder: (context, model) {
            return Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: model.imageUrl,
                    fadeOutDuration: Duration(),
                    placeholder: (context, url) => Icon(
                      Icons.image,
                      color: Colors.grey[100],
                      size: Insets.x25,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.0, 0.3, 1],
                      colors: [
                        Colors.grey[800].withOpacity(0.45),
                        Colors.grey[800].withOpacity(0.2),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: Insets.x4_5,
                  left: Insets.x4_5,
                  child: Text(
                    model.restaurantName,
                    style: textTheme.headline3.copyWith(
                      color: BrandingColors.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );

  Widget _buildRestaurantsList() => SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, index) {
            final model = bloc.restaurantsList[index];
            return Column(
              children: [
                FractionallySizedBox(
                  widthFactor: 0.92,
                  child: Card(
                    clipBehavior: Clip.antiAlias,
                    shadowColor: BrandingColors.background,
                    elevation: 0.8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Radiuses.big_1x),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 160,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Container(
                                height: double.infinity,
                                width: double.infinity,
                                color: Colors.grey[300],
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: model.imageUrl,
                                  fadeOutDuration: Duration(),
                                  placeholder: (context, url) => Icon(
                                    Icons.image,
                                    color: Colors.grey[100],
                                    size: Insets.x25,
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    stops: [0.0, 0.3, 1],
                                    colors: [
                                      Colors.grey[800].withOpacity(0.3),
                                      Colors.grey[800].withOpacity(0.1),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                top: Insets.x2,
                                left: Insets.x2,
                                child: Column(
                                  children: [],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.all(Insets.x4_5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  model.name,
                                  style: textTheme.headline3,
                                ),
                                SizedBox(
                                  height: Insets.x1,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(Radiuses.normal),
                                        ),
                                      ),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.all(Insets.x1_5),
                                        child: Text(
                                          "${model.minDeliveryTime}-${model.maxDeliveryTime} min",
                                          style: textTheme.subtitle2,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: Insets.x2,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(Radiuses.normal),
                                        ),
                                      ),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.all(Insets.x1_5),
                                        child: Text(
                                          "From ${model.minOrderPrice.value} ${model.minOrderPrice.currency}",
                                          style: textTheme.subtitle2,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: Insets.x2),
              ],
            );
          },
          childCount: bloc.restaurantsList.length,
        ),
      );

  Widget _buildShimmerSectionTitle({
    bool isNeedTopSpacing = false,
  }) =>
      SliverToBoxAdapter(
        child: Column(
          children: [
            if (isNeedTopSpacing) SizedBox(height: Insets.x5),
            SizedBox(
              height: Insets.x6,
              child: FractionallySizedBox(
                widthFactor: 0.90,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Shimmer.fromColors(
                    baseColor: Colors.grey[400],
                    highlightColor: Colors.grey[300],
                    child: Container(
                      height: 14,
                      width: 130,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(Radiuses.small_3x),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  Widget _buildShimmerLaneWithTitle() => SliverToBoxAdapter(
        child: HorizontalShimmerSwipeLane(),
      );

  Widget _buildShimmerList() => SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, index) {
            return Column(
              children: [
                SizedBox(
                  height: 256,
                  child: FractionallySizedBox(
                    widthFactor: 0.92,
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      shadowColor: BrandingColors.background,
                      elevation: 0.8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Radiuses.big_1x),
                      ),
                      child: ShimmerContent(),
                    ),
                  ),
                ),
                SizedBox(height: Insets.x2),
              ],
            );
          },
          childCount: 3,
        ),
      );

  Widget _buildBottomSpacingSliver() => SliverToBoxAdapter(
        child: SizedBox(height: kBottomNavigationBarHeight),
      );
}
