import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/config/api_config.dart';
import 'package:frontend/screens/student_details.dart';
import 'package:frontend/widgets/search_results.dart';
import 'package:frontend/widgets/student_card.dart';
import 'package:http/http.dart' as http;

import '../models/student.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {

  final TextEditingController searchController = TextEditingController();

  List<Student> allStudents = [];
  List<Student> filteredStudents = [];
  Map<String, Student> studentCache = {};

  bool isLoading = true;
  String errorMessage = '';
  int currentPage = 0;
  String generatedSql = '';
  bool isSearchMode = false;

  @override
  void initState() {
    super.initState();
    fetchStudents();
    searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchStudents() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
      generatedSql = '';
      isSearchMode = false;
    });

    try {
      final response = await http.get(Uri.parse(ApiConfig.dashboardApiUrl));

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);

        List<dynamic> data = [];
        if (decoded is List) {
          data = decoded;
        } else if (decoded is Map<String, dynamic>) {
          data =
              decoded['data'] ?? decoded['result'] ?? decoded['results'] ?? [];
        }

        final students =
            data
                .whereType<Map<String, dynamic>>()
                .map((item) => Student.fromJson(item))
                .toList();

        setState(() {
          allStudents = students;
          filteredStudents = students;
          currentPage = 0;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load students: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error: $e';
      });
    }
  }

  Future<void> searchWithNaturalLanguage(String userQuery) async {
    final query = userQuery.trim();

    if (query.isEmpty) {
      fetchStudents();
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
      generatedSql = '';
      isSearchMode = true;
    });

    try {
      final response = await http.post(
        Uri.parse(ApiConfig.nl2SqlApiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'query': query}),
      );

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);

        if (decoded is! Map<String, dynamic>) {
          setState(() {
            isLoading = false;
            errorMessage = 'Invalid response format';
          });
          return;
        }

        final List<dynamic> results =
            decoded['result'] ?? decoded['results'] ?? decoded['data'] ?? [];

        final String sql =
            decoded['generatedSql']?.toString() ??
            decoded['sql']?.toString() ??
            '';

        final students =
            results
                .whereType<Map<String, dynamic>>()
                .map((item) => Student.fromJson(item))
                .toList();

        setState(() {
          filteredStudents = students;
          generatedSql = sql;
          currentPage = 0;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Search failed: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error: $e';
      });
    }
  }

  void clearSearch() {
    searchController.clear();
    fetchStudents();
  }

  int getColumns(double width) {
    if (width >= 1600) return 7;
    if (width >= 1400) return 6;
    if (width >= 1100) return 5;
    if (width >= 850) return 4;
    if (width >= 650) return 3;
    return 2;
  }

  int getRows() => 2;

  int getItemsPerPage(double width) {
    return getColumns(width) * getRows();
  }

  int totalPages(double width) {
    final itemsPerPage = getItemsPerPage(width);
    if (filteredStudents.isEmpty) return 1;
    return (filteredStudents.length / itemsPerPage).ceil();
  }

  List<Student> getCurrentPageStudents(double width) {
    final itemsPerPage = getItemsPerPage(width);
    final start = currentPage * itemsPerPage;

    if (start >= filteredStudents.length) return [];

    final end =
        (start + itemsPerPage > filteredStudents.length)
            ? filteredStudents.length
            : start + itemsPerPage;

    return filteredStudents.sublist(start, end);
  }

  void goToNextPage(double width) {
    if (currentPage < totalPages(width) - 1) {
      setState(() {
        currentPage++;
      });
    }
  }

  void goToPreviousPage() {
    if (currentPage > 0) {
      setState(() {
        currentPage--;
      });
    }
  }

  Future<Student?> fetchStudentDetails(String rollNo) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.studentDetailsApiUrl}/${Uri.encodeComponent(rollNo)}'),
      );

      debugPrint(
        'Student details URL: ${ApiConfig.studentDetailsApiUrl}/${Uri.encodeComponent(rollNo)}',
      );
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic decoded = jsonDecode(response.body);

        Map<String, dynamic>? studentMap;

        if (decoded is Map<String, dynamic>) {
          if (decoded['data'] is Map<String, dynamic>) {
            studentMap = decoded['data'];
          } else if (decoded['result'] is Map<String, dynamic>) {
            studentMap = decoded['result'];
          } else if (decoded['student'] is Map<String, dynamic>) {
            studentMap = decoded['student'];
          } else {
            studentMap = decoded;
          }
        }

        if (studentMap != null) {
          debugPrint('Parsed student map: $studentMap');
          return Student.fromJson(studentMap);
        }
      }
    } catch (e) {
      debugPrint('Student details fetch error: $e');
    }
    return null;
  }

  Future<void> openStudentDetails(Student student) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final detailedStudent = await fetchStudentDetails(student.rollNo);

      if (!mounted) return;
      Navigator.pop(context);

      if (detailedStudent != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StudentDetailsPage(student: detailedStudent),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StudentDetailsPage(student: student),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F8),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final columns = getColumns(screenWidth);
            final rows = getRows();
            final pageStudents = getCurrentPageStudents(screenWidth);
            final pageCount = totalPages(screenWidth);

            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth < 900 ? 16.0 : 24.0,
                vertical: screenWidth < 900 ? 16.0 : 20.0,
              ),
              child: Column(
                children: [
                  _topBar(),
                  const SizedBox(height: 18),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(screenWidth < 900 ? 16 : 24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFEAEAEA)),
                      ),
                      child:
                          isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : errorMessage.isNotEmpty
                              ? Center(
                                child: Text(
                                  errorMessage,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              )
                              : filteredStudents.isEmpty
                              ? const Center(
                                child: Text(
                                  'No students found',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              )
                              : filteredStudents.length == 1 && isSearchMode
                              ? StudentDetailsView(
                                student: filteredStudents.first,
                                generatedSql: generatedSql,
                              )
                              : isSearchMode
                              ? SearchResultsList(
                                students: filteredStudents,
                                generatedSql: generatedSql,
                                onTapStudent: openStudentDetails,
                              )
                              : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _headerSection(
                                    screenWidth: screenWidth,
                                    totalStudents: filteredStudents.length,
                                    pageNumber: currentPage + 1,
                                    totalPages: pageCount,
                                  ),
                                  const SizedBox(height: 22),
                                  Expanded(
                                    child: Column(
                                      children: List.generate(rows, (row) {
                                        return Expanded(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                              bottom: row == rows - 1 ? 0 : 18,
                                            ),
                                            child: Row(
                                              children: List.generate(columns, (
                                                col,
                                              ) {
                                                final index =
                                                    row * columns + col;

                                                return Expanded(
                                                  child: Padding(
                                                    padding: EdgeInsets.only(
                                                      right:
                                                          col == columns - 1
                                                              ? 0
                                                              : 18,
                                                    ),
                                                    child:
                                                        index < pageStudents.length
                                                            ? _studentCard(
                                                              student:
                                                                  pageStudents[index],
                                                              screenWidth:
                                                                  screenWidth,
                                                            )
                                                            : const SizedBox(),
                                                  ),
                                                );
                                              }),
                                            ),
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                  const SizedBox(height: 18),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _navButton(
                                        icon: Icons.arrow_back_ios_new,
                                        onTap:
                                            currentPage > 0
                                                ? goToPreviousPage
                                                : null,
                                      ),
                                      const SizedBox(width: 16),
                                      _navButton(
                                        icon: Icons.arrow_forward_ios,
                                        onTap:
                                            currentPage < pageCount - 1
                                                ? () =>
                                                    goToNextPage(screenWidth)
                                                : null,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _topBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFEAEAEA)),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    searchWithNaturalLanguage(searchController.text);
                  },
                  icon: const Icon(
                    Icons.search,
                    color: Color(0xFF666666),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: TextField(
                    controller: searchController,
                    textInputAction: TextInputAction.search,
                    onSubmitted: searchWithNaturalLanguage,
                    decoration: InputDecoration(
                      hintText: 'Search with human-readable query',
                      hintStyle: const TextStyle(
                        color: Color(0xFF8A8A8A),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      border: InputBorder.none,
                      suffixIcon:
                          searchController.text.isNotEmpty
                              ? IconButton(
                                onPressed: clearSearch,
                                icon: const Icon(Icons.close),
                              )
                              : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 14),
        Container(
          height: 60,
          width: 60,
          decoration: BoxDecoration(
            color: const Color(0xFF111111),
            borderRadius: BorderRadius.circular(16),
          ),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.logout_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ],
    );
  }

  Widget _headerSection({
    required double screenWidth,
    required int totalStudents,
    required int pageNumber,
    required int totalPages,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Students Dashboard',
                style: TextStyle(
                  fontSize: screenWidth < 900 ? 22 : 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: const Color(0xFF111111),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Browse student photos and roll numbers clearly',
                style: TextStyle(
                  fontSize: screenWidth < 900 ? 13 : 15,
                  color: const Color(0xFF757575),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFF7F7F8),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$totalStudents Students',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 4),
              Text('Page $pageNumber / $totalPages'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _studentCard({required Student student, required double screenWidth}) {
    return StudentCardWidget(
      student: student,
      onTap: () => openStudentDetails(student),
    );
  }

  Widget _navButton({required IconData icon, required VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color:
              onTap == null ? const Color(0xFFF5F5F5) : const Color(0xFF111111),
          borderRadius: BorderRadius.circular(14),
          border:
              onTap == null ? Border.all(color: const Color(0xFFEAEAEA)) : null,
        ),
        child: Icon(
          icon,
          color: onTap == null ? const Color(0xFF999999) : Colors.white,
          size: 20,
        ),
      ),
    );
  }
}