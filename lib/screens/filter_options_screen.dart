import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FilterOption {
  final String name;
  final bool isSelected;

  FilterOption({required this.name, this.isSelected = false});

  FilterOption copyWith({String? name, bool? isSelected}) {
    return FilterOption(
      name: name ?? this.name,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

class FilterCategory {
  final String name;
  final List<FilterOption> options;
  final bool isExpanded;

  FilterCategory({
    required this.name,
    required this.options,
    this.isExpanded = false,
  });

  FilterCategory copyWith({
    String? name,
    List<FilterOption>? options,
    bool? isExpanded,
  }) {
    return FilterCategory(
      name: name ?? this.name,
      options: options ?? this.options,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }
}

class FilterOptionsScreen extends StatefulWidget {
  const FilterOptionsScreen({super.key});

  @override
  State<FilterOptionsScreen> createState() => _FilterOptionsScreenState();
}

class _FilterOptionsScreenState extends State<FilterOptionsScreen> {
  final TextEditingController _searchController = TextEditingController();

  // Selected filters
  final List<String> _selectedFilters = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button
            Padding(
              padding: EdgeInsets.only(left: 8.w, top: 8.h),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            // Search bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.filter_list,
                      color: Colors.grey[600],
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Filter by date or field...',
                          hintStyle: TextStyle(
                            fontFamily: 'Mulish',
                            color: Colors.grey[600],
                            fontSize: 14.sp,
                          ),
                          border: InputBorder.none,
                        ),
                        style: TextStyle(fontFamily: 'Mulish', fontSize: 14.sp),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Filter options
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // First Name
                    _buildFilterOption('First Name'),

                    // Field
                    _buildFilterOption('field'),

                    // Email
                    _buildFilterOption('Email'),

                    // Date
                    _buildFilterOption('Date', isHighlighted: true),

                    // Personality
                    _buildFilterOption('personality'),

                    // Bottom actions
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Add filter button
                          TextButton.icon(
                            onPressed: () {
                              // Add new filter logic
                            },
                            icon: Icon(
                              Icons.add,
                              color: Colors.blue,
                              size: 20.sp,
                            ),
                            label: Text(
                              'Add Filter',
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                color: Colors.blue,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),

                          // Clear all filters button
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _selectedFilters.clear();
                              });
                            },
                            child: Text(
                              'Clear all filters',
                              style: TextStyle(
                                fontFamily: 'Mulish',
                                color: Colors.grey[600],
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String name, {bool isHighlighted = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Option name
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Text(
            name,
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
        ),

        // Option background (highlighted for Date)
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: isHighlighted ? Colors.grey[200] : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),

        // Divider
        Divider(height: 1.h, color: Colors.grey[200]),
      ],
    );
  }
}
