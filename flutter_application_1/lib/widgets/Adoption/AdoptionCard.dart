import 'package:flutter/material.dart';

class AdoptionCard extends StatelessWidget {
  final Map<String, dynamic> animal;
  final VoidCallback onTap;
  final VoidCallback onFavourite;

  const AdoptionCard({
    super.key,
    required this.animal,
    required this.onTap,
    required this.onFavourite,
  });

  String _getAnimalEmoji(String? type) {
    switch (type) {
      case "Cat":   return "🐈";
      case "Dog":   return "🐕";
      case "Bird":  return "🦜";
      case "Rabbit":return "🐇";
      default:      return "🐾";
    }
  }

  Color get statusColor {
    switch (animal["status"]) {
      case "Homeless":
        return Colors.green;
      case "Pending":
        return Colors.orange;
      case "Adopted":
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isFav = animal["isFavourited"] ?? false;
    final bool isAvailable = animal["status"] == "Homeless";

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with overlays
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  child: Image.asset(
                    animal["image"],
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 200,                    // ← keep this
                      width: double.infinity,
                      color: Colors.grey[200],
                      alignment: Alignment.center,    // ← better centering
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _getAnimalEmoji(animal["animalType"]),
                            style: const TextStyle(fontSize: 70),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Image not found",
                            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Status badge top left
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      animal["status"],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Favourite button top right
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onFavourite,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? const Color(0xFFFF6B6B) : Colors.grey[400],
                        size: 20,
                      ),
                    ),
                  ),
                ),

                // Distance badge bottom left
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.location_on, color: Colors.white, size: 12),
                        const SizedBox(width: 3),
                        Text(
                          '${animal["distance"]} km away',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Card content
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + Breed
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        animal["name"],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.favorite, size: 14, color: Colors.pink[300]),
                          const SizedBox(width: 3),
                          Text(
                            '${animal["favourites"] ?? 0}',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${animal["breed"]} · ${animal["animalType"]}',
                    style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 10),

                  // Info chips row
                  Row(
                    children: [
                      _infoChip(
                        animal["sex"] == "Male" ? "♂" : "♀",
                        animal["sex"],
                        animal["sex"] == "Male" ? const Color(0xFFB3D9FF) : const Color(0xFFFFB3D9),
                        animal["sex"] == "Male" ? const Color(0xFF1A73E8) : const Color(0xFFE91E8C),
                      ),
                      const SizedBox(width: 8),
                      _infoChip("🎂", animal["age"], const Color(0xFFFFF3B3), const Color(0xFFF57F17)),
                      const SizedBox(width: 8),
                      _infoChip(
                        "💉",
                        animal["vaccinated"] ? "Vaccinated" : "Not Vacc.",
                        animal["vaccinated"] ? const Color(0xFFB3F0C8) : const Color(0xFFFFCDD2),
                        animal["vaccinated"] ? const Color(0xFF2E7D32) : const Color(0xFFC62828),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Tags
                  if (animal["tags"] != null)
                    Wrap(
                      spacing: 6,
                      children: (animal["tags"] as List).map<Widget>((tag) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                          ),
                        );
                      }).toList(),
                    ),

                  if (isAvailable) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF6B6B),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          'Tap to View & Apply for Adoption',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(String icon, String label, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}