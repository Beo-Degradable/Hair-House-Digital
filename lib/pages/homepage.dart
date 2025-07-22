import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hairhouse/pages/bookingtabs/branchdetail.dart';
import 'package:hairhouse/pages/package/profilebuttons/profile_section.dart';
import 'package:hairhouse/pages/package/widgets/customnavbar.dart';
import 'package:hairhouse/pages/booking.dart';
import 'package:hairhouse/pages/bookingtabs/services.dart';
import 'package:hairhouse/pages/products/products.dart';
import 'package:hairhouse/pages/products/cart.dart';
import 'package:hairhouse/pages/camera.dart';
import 'package:hairhouse/pages/package/profilebuttons/drawer.dart';
import 'package:hairhouse/pages/package/user_data.dart';
import 'package:hairhouse/pages/notifications.dart';
import 'package:hairhouse/pages/package/widgets/promo_gallery.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> myCart = [];

  int _selectedIndex = 0;
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _productSearchQuery = '';
  FocusNode _searchFocusNode = FocusNode();
  String firstName = '';
  String lastName = '';
  String email = '';

  final List<String> _services = ['Haircut', 'Coloring', 'Styling', 'Shaving'];
  final List<String> _products = ['Shampoo', 'Conditioner', 'Gel', 'Wax'];

  final List<String> _promoImages = [
    'images/1.jpg',
    'images/2.webp',
    'images/3.jpg',
    'images/4.jpg',
    'images/5.jpg',
    'images/7.jpg'
  ];

  @override
  void initState() {
    super.initState();
    loadUserInfo();
  }

  Future<void> loadUserInfo() async {
    final fName = await UserData.getFirstName();
    final lName = await UserData.getLastName();
    final userEmail = await UserData.getEmail();

    setState(() {
      firstName = fName ?? '';
      lastName = lName ?? '';
      email = userEmail ?? '';
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _searchQuery = '';
      _searchController.clear();
      _searchFocusNode.unfocus();
      if (index != 3) _productSearchQuery = '';
    });
  }

  List<String> _getSearchResults() {
    if (_searchQuery.isEmpty) return [];
    final query = _searchQuery.toLowerCase();
    final serviceResults =
        _services.where((s) => s.toLowerCase().contains(query)).toList();
    final productResults =
        _products.where((p) => p.toLowerCase().contains(query)).toList();
    return [...serviceResults, ...productResults];
  }

  String _getTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Home';
      case 1:
        return 'Booking';
      case 2:
        return 'Camera';
      case 3:
        return 'Products';
      case 4:
        return 'Services';
      default:
        return 'HairHouse';
    }
  }

  Widget _buildPageContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return BookingTabPage();
      case 2:
        return CameraPage();
      case 3:
        return ProductsPage(
          cart: myCart,
          searchQuery: _productSearchQuery,
          onCartUpdated: () {
            setState(() {}); // rebuild to reflect cart changes
          },
        );
      case 4:
        return ServicesPage();
      default:
        return Center(child: Text("Page not found"));
    }
  }

  Widget _buildHomeContent() {
    final searchResults = _getSearchResults();
    final bool showResults = _searchQuery.isNotEmpty;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (_searchFocusNode.hasFocus) {
          _searchFocusNode.unfocus();
          setState(() {
            _searchQuery = '';
            _searchController.clear();
          });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/bg.jpg'), // ✅ your background asset path
            fit: BoxFit.cover, // cover entire page
          ),
        ),
        child: Stack(
          children: [
            ListView(
              padding: EdgeInsets.all(16),
              children: [
                // 👤 Profile Edit Button Example
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hello, $firstName $lastName!',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors
                                    .white, // ✅ ensure visibility if bg is dark
                              ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.amber),
                      onPressed: () async {
                        final updated = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileSection(),
                          ),
                        );

                        if (updated != null) {
                          await loadUserInfo(); // reload from UserData for consistency
                        }
                      },
                    ),
                  ],
                ),
                Text(
                  'Good Morning!',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                      ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 31, 30, 30)
                        .withOpacity(0.9), // ✅ to read over bg
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (query) {
                    setState(() {
                      _searchQuery = query;
                    });
                  },
                  onSubmitted: (query) {
                    if (query.trim().isEmpty) return;
                    if (_products.any(
                        (p) => p.toLowerCase().contains(query.toLowerCase()))) {
                      setState(() {
                        _productSearchQuery = query;
                        _onItemTapped(3); // Switch to Products tab
                      });
                    }
                  },
                ),
                SizedBox(height: 16),
                if (!showResults) ...[
                  SizedBox(height: 16),
                  Text(
                    'Special Offers',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[700],
                    ),
                  ),
                  SizedBox(height: 8),
                  PromoGallery(promoImages: _promoImages),
                  SizedBox(height: 16),
                  HairstylistsSection(),
                  SizedBox(height: 16),
                  NearbySalonsSection(),
                  SizedBox(height: 16),
                  FeaturedServicesSection(),
                  SizedBox(height: 32),
                ]
              ],
            ),
            if (showResults && searchResults.isNotEmpty)
              Positioned.fill(
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      _searchQuery = '';
                      _searchController.clear();
                    });
                  },
                  child: Container(
                    color: Colors.transparent,
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.fromLTRB(16, 140, 16, 16),
                    child: Material(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(12),
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'Search Results:',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          ...searchResults.map(
                            (result) => ListTile(
                              title: Text(result),
                              onTap: () {
                                if (_products.any((p) =>
                                    p.toLowerCase() == result.toLowerCase())) {
                                  setState(() {
                                    _productSearchQuery = result;
                                    _onItemTapped(3);
                                  });
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle()),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartPage(cart: myCart)),
              );
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotificationPage()),
                  );
                  setState(() {}); // Refresh badge after viewing
                },
              ),
              if (notifications.isNotEmpty)
                Positioned(
                  right: 11,
                  top: 11,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: BoxConstraints(
                      minWidth: 10,
                      minHeight: 10,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      drawer: MyDrawer(
        firstName: firstName,
        lastName: lastName,
        email: email,
      ),
      body: _buildPageContent(),
      bottomNavigationBar: CustomNavbar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HairstylistsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Hairstylists',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (_, index) => Container(
                width: 140,
                margin: EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: Text('Stylist ${index + 1}')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NearbySalonsSection extends StatelessWidget {
  final List<Map<String, dynamic>> branches = [
    {
      'name': 'Hair House Salon',
      'location': '23A Evalista St, Poblacion, Batangas City, 4200 Batangas',
      'services': ['Hair', 'Nail'],
      'image': 'images/verg.png',
      'stylists': ['Stylist A', 'Stylist B', 'Stylist C'],
    },
    {
      'name': 'Hair House lawas Branch',
      'location':
          '2F Junction Commercial Complex,P. Burgos, Batangas City, 4200 Batangas',
      'services': ['Hair', 'Nail', 'Skin'],
      'image': 'images/lawas.png',
      'stylists': ['Stylist D', 'Stylist E'],
    },
    {
      'name': 'Hair House Salon Luxury',
      'location': 'Lipa City, 4217 Batangas',
      'services': ['Hair', 'Skin'],
      'image': 'images/luxury.webp',
      'stylists': ['Stylist F', 'Stylist G', 'Stylist H'],
    },
    {
      'name': 'Hair House Salon',
      'location':
          '225 President Jose P. Laurel Highway, Tanauan City, Batangas',
      'services': ['Hair', 'Nail', 'Skin'],
      'image': 'images/lipa.png',
      'stylists': ['Stylist K', 'Stylist L', 'Stylist M'],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nearby Branches',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: branches.map((branch) {
                return Container(
                  width: 220,
                  margin: EdgeInsets.only(right: 12),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BranchesPage(branch: branch),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.network(
                              branch['image'],
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  branch['name'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  branch['location'],
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey[600]),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Services:',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
                                SizedBox(height: 4),
                                Wrap(
                                  spacing: 4,
                                  children: branch['services']
                                      .map<Widget>((service) => Chip(
                                            label: Text(service,
                                                style: TextStyle(fontSize: 12)),
                                            backgroundColor: Colors.black54,
                                          ))
                                      .toList(),
                                ),
                                SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              BranchesPage(branch: branch),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.amberAccent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text('Book'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class FeaturedServicesSection extends StatefulWidget {
  @override
  _FeaturedServicesSectionState createState() =>
      _FeaturedServicesSectionState();
}

class _FeaturedServicesSectionState extends State<FeaturedServicesSection> {
  String selectedCategory = 'Hair';

  final Map<String, List<Map<String, String>>> services = {
    'Hair': [
      {
        'name': 'Haircut',
        'desc': 'Classic cut by expert stylists.',
        'price': '₱200',
        'image': 'images/haircut.webp'
      },
      {
        'name': 'Brazillian',
        'desc': 'Smoothens and removes frizz.',
        'price': '₱1499',
        'image': 'images/brazilian.jpg'
      },
      {
        'name': 'Highlights',
        'desc': 'Adds colored streaks for dimension.',
        'price': '₱1499',
        'image': 'images/highlights.jpg'
      },
      {
        'name': 'Keratin Treatment',
        'desc': 'Smoothens and adds shine.',
        'price': '₱999',
        'image': 'images/keratin.jpg'
      },
      {
        'name': 'Monotone Color',
        'desc': 'Single full hair color.',
        'price': '₱1499',
        'image': 'images/monotone.jpg'
      },
    ],
    'Nails': [
      {
        'name': 'Manicure',
        'desc': 'Relaxing nail care session.',
        'price': '₱250',
        'image': 'images/manicure.jpg'
      },
      {
        'name': 'Gel Polish',
        'desc': 'Long-lasting and shiny.',
        'price': '₱400',
        'image': 'images/gel.jpg'
      },
      {
        'name': 'Pedicure',
        'desc': 'Nail cleaning + polish (feet).',
        'price': '₱250',
        'image': 'images/pedicure.jpg'
      },
    ],
    'Skin': [
      {
        'name': 'Facial Treartment',
        'desc': 'Deep cleansing and hydration.',
        'price': '₱700',
        'image': 'images/facial.jpg'
      },
      {
        'name': 'Underarm Whitening/Laser',
        'desc': 'Lightens skin and removes hair.',
        'price': '₱3200',
        'image': 'images/underarm.jpg'
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> selectedServices =
        services[selectedCategory]!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Popular Services',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: ['Hair', 'Nails', 'Skin'].map((category) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(category),
                  selected: selectedCategory == category,
                  onSelected: (_) {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                ),
              );
            }).toList(),
          ),
        ),
        SizedBox(height: 16),
        Container(
          height: 280,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 12),
            itemCount: selectedServices.length + 1,
            separatorBuilder: (_, __) => SizedBox(width: 12),
            itemBuilder: (context, index) {
              if (index < selectedServices.length) {
                final service = selectedServices[index];
                return TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 600),
                  tween: Tween(begin: 50, end: 0),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return AnimatedOpacity(
                      duration: Duration(milliseconds: 500),
                      opacity: value == 0 ? 1 : 0,
                      child: AnimatedSlide(
                        offset: Offset(0, value / 100),
                        duration: Duration(milliseconds: 500),
                        child: child,
                      ),
                    );
                  },
                  child: SizedBox(
                    width: 260,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(12)),
                            child: Image.asset(
                              service['image']!,
                              height: 110,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(service['name']!,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 6),
                                Text(service['desc']!,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                                SizedBox(height: 6),
                                Text('Price: ${service['price']}',
                                    style: TextStyle(
                                        color: Colors.amber[800],
                                        fontWeight: FontWeight.bold)),
                                SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => BookingTabPage(),
                                        ),
                                      );
                                    },
                                    child: Text('Book Now'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                // "See More" Card
                return SizedBox(
                  width: 260,
                  child: GestureDetector(
                    onTap: () {
                      // Implement "See More" nav if needed
                    },
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: AssetImage('images/see_more_bg.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                'See More >',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
