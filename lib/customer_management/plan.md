# Customer Management Evolution Plan

## Vision
Transform the basic customer management system into a competitive booking platform that rivals Bokun/FareHarbor while leveraging unique musher-specific advantages. Focus on dog sled operation realities and seamless integration with existing team builder.

## Current Architecture

### Data Models
```
Customer -> Booking -> CustomerGroup -> TeamGroup (1:1)
```

- **Customer**: Individual person (name, email, age, weight, isSingleDriver, isDriving)
- **Booking**: Group payment unit (multiple customers, pricing, payment status)
- **CustomerGroup**: Time slot handler (datetime, name, teamGroupId)
- **TeamGroup**: Dog/route handler (distance in km, teams, dogs)

### Current Features
- Basic list views (Today, Tomorrow, Next 7 days)
- Warning system (orphaned bookings, unpaid, unassigned teams)
- Simple CRUD operations via dialog editors
- 1:1 CustomerGroup ↔ TeamGroup integration

## Phase 1: Core Booking System

### 1. Calendar & Availability Management
**Priority: Critical**

#### Calendar View
- Month/week/day calendar interface DONE!
- Visual representation of bookings by date/time DONE!
- Color coding by route/distance
- Capacity indicators per time slot

#### Availability System
- Kennel configures available time slots
- Set total capacity per slot (based on dog pool)
- Multiple routes can run simultaneously at same time
- Real-time capacity tracking (16 total, 4 booked = 12 remaining)

#### Capacity Logic
- **Single drivers count as 2 capacity units** (need own sled)
- **Children count as 1 capacity unit**
- Total kennel capacity shared across all routes at same time
- Kennel decides capacity allocation per route

### 2. Slot = CustomerGroup Logic
**Priority: Critical**

#### Auto-Creation Rules
- First booking at DateTime + Route → Creates CustomerGroup automatically
- Subsequent bookings at same DateTime + Route → Added to existing CustomerGroup
- CustomerGroup.name auto-generated from DateTime + Route
- 1:1 CustomerGroup ↔ TeamGroup maintained

#### Route Handling
- TeamGroup.distance (double, km) determines route
- Multiple CustomerGroups can exist at same DateTime for different routes
- Each CustomerGroup gets its own TeamGroup with specific distance

### 3. Enhanced Booking Flow
**Priority: High**

#### Customer-Facing Booking
- Calendar widget showing available slots
- Route selection (10k, 20k, family, etc.)
- Capacity-aware booking (show remaining spots)
- Single driver specification affects capacity calculation
- Real-time availability updates

#### Kennel Management
- Drag & drop booking management
- Move bookings between time slots
- Bulk operations (cancel all bookings for a day)
- Override capacity limits when needed

### 4. Payment Integration
**Priority: High**

#### Stripe Connect
- Direct payment to kennel accounts
- Platform fee collection for Mush On
- Support for invoicing B2B clients
- Payment plan options for tour operators

#### Payment States
- Paid/Unpaid tracking (existing)
- Partial payment support
- Refund management
- Automated payment reminders

### 5. Team Builder Integration
**Priority: Medium**

#### Validation Rules
- Single driver constraint: If any customer.isSingleDriver → max 1 person per sled
- Capacity validation: Team capacity must match CustomerGroup size
- Error messaging for invalid team configurations

#### Enhanced Customer Tab
- Display customer preferences (single driver, weight, driving ability)
- Visual indicators for special requirements
- Automatic sled assignment suggestions based on customer data

## Phase 2: Professional Features

### 1. Digital Waivers & Documentation
- Integrated signature pad
- Template-based waiver system
- Automatic email delivery
- Digital record keeping

### 2. Communication System
- Pre-tour email templates (gear recommendations, what to expect)
- Post-tour follow-up with photos/videos
- Weather warnings and tour updates
- SMS/email notification system

### 3. Weather Integration
- Automatic weather data via API (kennel sets location in settings)
- Kennel-defined weather thresholds for warnings/cancellations
- Route-specific weather considerations
- Automatic customer notifications for weather issues

### 4. Tour Operator Portal
- B2B booking interface
- Credit terms and invoicing
- Bulk booking capabilities
- Operator-specific pricing and terms

## Phase 3: Advanced Features

### 1. Customer Experience Platform
- Post-tour photo/video sharing
- Dog and team information pages
- Weather conditions during tour
- Social sharing integration
- Digital tour memories package

### 2. Analytics & Insights
- Revenue forecasting
- Booking pattern analysis
- Capacity optimization suggestions
- Customer behavior insights

### 3. Mobile Applications
- Guide mobile app for tour management
- Customer mobile experience
- Real-time tour tracking
- Emergency procedures access

## Technical Considerations

### Database Schema Updates
```dart
// Enhanced models needed:
class AvailabilitySlot {
  DateTime datetime;
  List<String> availableRoutes;  // ["10k", "20k", "family"]
  int totalCapacity;
  Map<String, int> routeCapacity; // Manual allocation by kennel
}

class WeatherSettings {
  String location;
  double minTemp;
  double maxTemp;
  List<String> warningConditions;
}

class KennelSettings {
  List<AvailabilitySlot> recurringSchedule;
  WeatherSettings weather;
  int defaultBookingWindow; // hours
  StripeConnectSettings payments;
}
```

### Integration Points
- Existing Riverpod providers for CustomerGroup/TeamGroup
- Firebase Auth for multi-tenant kennel accounts
- Stripe Connect API for payments
- Weather API integration
- Email service (SendGrid/similar)

### UI/UX Priorities
- Calendar component (consider Syncfusion Calendar)
- Drag & drop interfaces
- Mobile-responsive design
- Professional booking flow

## Success Metrics

### Phase 1 Goals
- Replace basic list view with calendar interface
- Implement capacity-aware booking system
- Stripe Connect integration working
- Team builder constraints enforced

### Business Objectives
- Compete with Bokun/FareHarbor on core booking features
- Differentiate through dog sled specific functionality
- Sustainable revenue model via platform fees
- Professional image for kennel operators

## Implementation Strategy

### Development Order
1. **Availability Management System** - Foundation for everything
2. **Calendar View** - Essential UX improvement
3. **CustomerGroup Auto-Creation** - Core booking logic
4. **Capacity Calculations** - Business logic
5. **Stripe Connect** - Revenue model
6. **Team Builder Constraints** - Integration polish

### Risk Mitigation
- Start with simple calendar, enhance iteratively
- Keep existing functionality working during transition
- Test capacity calculations thoroughly with edge cases
- Stripe Connect requires careful testing in sandbox environment

## Future Considerations

- Multi-language support for international kennels
- Advanced pricing strategies (dynamic, seasonal)
- Integration with tourism booking platforms
- White-label solutions for larger kennel chains
- AI-powered optimization suggestions (Phase 4+)

---

*This plan prioritizes practical booking system functionality while maintaining the unique advantages of integrated dog sled team management. Each phase builds upon the previous while delivering immediate value to kennel operators.*
