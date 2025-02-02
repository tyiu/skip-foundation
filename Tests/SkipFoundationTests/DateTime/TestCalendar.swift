// Copyright 2023 Skip
//
// This is free software: you can redistribute and/or modify it
// under the terms of the GNU Lesser General Public License 3.0
// as published by the Free Software Foundation https://fsf.org
import Foundation
import XCTest

// These tests are adapted from https://github.com/apple/swift-corelibs-foundation/blob/main/Tests/Foundation/Tests which have the following license:


// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2019 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//

class TestCalendar: XCTestCase {

    func test_allCalendars() {
        #if !SKIP
        for identifier in [
            Calendar.Identifier.buddhist,
            Calendar.Identifier.chinese,
            Calendar.Identifier.coptic,
            Calendar.Identifier.ethiopicAmeteAlem,
            Calendar.Identifier.ethiopicAmeteMihret,
            Calendar.Identifier.gregorian,
            Calendar.Identifier.hebrew,
            Calendar.Identifier.indian,
            Calendar.Identifier.islamic,
            Calendar.Identifier.islamicCivil,
            Calendar.Identifier.islamicTabular,
            Calendar.Identifier.islamicUmmAlQura,
            Calendar.Identifier.iso8601,
            Calendar.Identifier.japanese,
            Calendar.Identifier.persian,
            Calendar.Identifier.republicOfChina
            ] as [Calendar.Identifier] {
                let calendar = Calendar(identifier: identifier)
                XCTAssertEqual(identifier,calendar.identifier)
        }
        #else
        XCTAssertEqual(Calendar.Identifier.gregorian, Calendar(identifier: Calendar.Identifier.gregorian).identifier)
        #endif
    }

    func test_gettingDatesOnGregorianCalendar() {
        let date = Date(timeIntervalSince1970: 1449332351)

        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let components = calendar.dateComponents(Set([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day]), from: date)

        XCTAssertEqual(components.year, 2015)
        XCTAssertEqual(components.month, 12)
        XCTAssertEqual(components.day, 5)

        // Test for problem reported by Malcolm Barclay via swift-corelibs-dev
        // https://lists.swift.org/pipermail/swift-corelibs-dev/Week-of-Mon-20161128/001031.html
        let fromDate = Date()
        let interval = 200
        let toDate = Date(timeInterval: TimeInterval(interval), since: fromDate)
        #if SKIP
        throw XCTSkip("TODO: dateComponents interval calculations")
        #endif
        let fromToComponents = calendar.dateComponents(Set([Calendar.Component.second]), from: fromDate, to: toDate)
        XCTAssertEqual(fromToComponents.second, interval);

        // Issue with 32-bit CF calendar vector on Linux
        // Crashes on macOS 10.12.2/Foundation 1349.25
        // (Possibly related) rdar://24384757
        /*
        let interval2 = Int(INT32_MAX) + 1
        let toDate2 = Date(timeInterval: TimeInterval(interval2), since: fromDate)
        let fromToComponents2 = calendar.dateComponents([.second], from: fromDate, to: toDate2)
        XCTAssertEqual(fromToComponents2.second, interval2);
        */
    }

    func test_gettingDatesOnISO8601Calendar() {
        #if SKIP
        throw XCTSkip("Skip: unsupported ISO8601Calendar")
        #else
        let date = Date(timeIntervalSince1970: 1449332351)

        var calendar = Calendar(identifier: .iso8601)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let components = calendar.dateComponents([.year, .month, .day], from: date)

        XCTAssertEqual(components.year, 2015)
        XCTAssertEqual(components.month, 12)
        XCTAssertEqual(components.day, 5)
        #endif // !SKIP
    }


    func test_gettingDatesOnHebrewCalendar() {
        #if SKIP
        throw XCTSkip("Skip: unsupported HebrewCalendar")
        #else
        let date = Date(timeIntervalSince1970: 1552580351)

        var calendar = Calendar(identifier: .hebrew)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        XCTAssertEqual(components.year, 5779)
        XCTAssertEqual(components.month, 7)
        XCTAssertEqual(components.day, 7)
        XCTAssertEqual(components.isLeapMonth, false)
        #endif // !SKIP
    }

    func test_gettingDatesOnChineseCalendar() {
        #if SKIP
        throw XCTSkip("Skip: unsupported ChineseCalendar")
        #else
        let date = Date(timeIntervalSince1970: 1591460351.0)

        var calendar = Calendar(identifier: .chinese)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        XCTAssertEqual(components.year, 37)
        XCTAssertEqual(components.month, 4)
        XCTAssertEqual(components.day, 15)
        XCTAssertEqual(components.isLeapMonth, true)
        #endif // !SKIP
    }

    func test_gettingDatesOnPersianCalendar() {
        #if SKIP
        throw XCTSkip("Skip: unsupported PersianCalendar")
        #else
        let date = Date(timeIntervalSince1970: 1539146705)

        var calendar = Calendar(identifier: .persian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        XCTAssertEqual(components.year, 1397)
        XCTAssertEqual(components.month, 7)
        XCTAssertEqual(components.day, 18)

        #endif // !SKIP
    }
    
    func test_gettingDatesOnJapaneseCalendar() throws {
        #if SKIP
        throw XCTSkip("Skip: unsupported JapaneseCalendar")
        #else
        var calendar = Calendar(identifier: .japanese)
        calendar.timeZone = try XCTUnwrap( TimeZone(identifier: "UTC") )
        calendar.locale = Locale(identifier: "en_US_POSIX")
        
        do {
            let date = Date(timeIntervalSince1970: 1556633400) // April 30, 2019
            let components = calendar.dateComponents([.era, .year, .month, .day], from: date)
            XCTAssertEqual(calendar.eraSymbols[try XCTUnwrap(components.era)], "Heisei")
            XCTAssertEqual(components.year, 31)
            XCTAssertEqual(components.month, 4)
            XCTAssertEqual(components.day, 30)
        }
        
        // Test for new Japanese calendar era (starting from May 1, 2019)
        do {
            let date = Date(timeIntervalSince1970: 1556719800) // May 1, 2019
            let components = calendar.dateComponents([.era, .year, .month, .day], from: date)
            XCTAssertEqual(calendar.eraSymbols[try XCTUnwrap(components.era)], "Reiwa")
            XCTAssertEqual(components.year, 1)
            XCTAssertEqual(components.month, 5)
            XCTAssertEqual(components.day, 1)
        }
        #endif // !SKIP
    }

    func test_ampmSymbols() {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        XCTAssertEqual(calendar.amSymbol, "AM")
        XCTAssertEqual(calendar.pmSymbol, "PM")
    }

    func test_currentCalendarRRstability() {
        var AMSymbols = Array<String>()
        for _ in 1...10 {
            let cal = Calendar.current
            AMSymbols.append(cal.amSymbol)
        }

        XCTAssertEqual(AMSymbols.count, 10, "Accessing current calendar should work over multiple callouts")
    }

    func test_copy() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        var calendar = Calendar.current

        //Mutate below fields and check if change is being reflected in copy.
        calendar.firstWeekday = 2
        calendar.minimumDaysInFirstWeek = 2

        let copy = calendar
        XCTAssertTrue(copy == calendar)

        //verify firstWeekday and minimumDaysInFirstWeek of 'copy'.
        calendar.firstWeekday = 3
        calendar.minimumDaysInFirstWeek = 3
        XCTAssertEqual(copy.firstWeekday, 2)
        XCTAssertEqual(copy.minimumDaysInFirstWeek, 2)
        #endif // !SKIP
    }

    func test_component() {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let thisDay = calendar.date(from: DateComponents(year: 2016, month: 10, day: 4))!
        XCTAssertEqual(calendar.component(.year, from: thisDay), 2016)
        XCTAssertEqual(calendar.component(.month, from: thisDay), 10)
        XCTAssertEqual(calendar.component(.day, from: thisDay), 4)
    }

    func test_addingDates() {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let thisDay = calendar.date(from: DateComponents(year: 2016, month: 10, day: 4))!

        let thisDayComponents = calendar.dateComponents(Set([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day]), from: thisDay)
        XCTAssertEqual(thisDayComponents.year, 2016)
        XCTAssertEqual(thisDayComponents.month, 10)
        XCTAssertEqual(thisDayComponents.day, 4)

        let diffComponents = DateComponents(day: 1)
        let dayAfter = calendar.date(byAdding: diffComponents, to: thisDay)

        let dayAfterComponents = calendar.dateComponents(Set([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day]), from: dayAfter!)
        XCTAssertEqual(dayAfterComponents.year, 2016)
        XCTAssertEqual(dayAfterComponents.month, 10)
        XCTAssertEqual(dayAfterComponents.day, 5)

        let diffComponents30 = DateComponents(day: 30)

        let monthAfter = calendar.date(byAdding: diffComponents30, to: thisDay, wrappingComponents: true)

        let monthAfterComponents = calendar.dateComponents(Set([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day]), from: monthAfter!)
        XCTAssertEqual(monthAfterComponents.year, 2016)
        XCTAssertEqual(monthAfterComponents.month, 10)
        XCTAssertEqual(monthAfterComponents.day, 3)
    }

    func test_addingDates_issue182() {
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(identifier: "UTC")!
        let startDate = Date(timeIntervalSince1970: 0)

        do {
            let comps = calendar.dateComponents(Set([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day]), from: startDate)

            XCTAssertEqual(comps.year, 1970)
            XCTAssertEqual(comps.month, 1)
            XCTAssertEqual(comps.day, 1)
        }

        // testing with and without wrapping
        do {
            let endDate = calendar.date(byAdding: .day, value: 60, to: startDate, wrappingComponents: true)!

            let comps = calendar.dateComponents(Set([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day]), from: endDate)

            XCTAssertEqual(comps.year, 1970)
            XCTAssertEqual(comps.month, 1)
            XCTAssertEqual(comps.day, 30)
        }

        do {
            let endDate = calendar.date(byAdding: .day, value: 60, to: startDate)!

            let comps = calendar.dateComponents(Set([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day]), from: endDate)

            XCTAssertEqual(comps.year, 1970)
            XCTAssertEqual(comps.day, 2)
            XCTAssertEqual(comps.month, 3)
        }

    }

    func test_addingComponents() {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let thisDay = calendar.date(from: DateComponents(year: 2016, month: 10, day: 4))!
        let dayAfter = calendar.date(byAdding: .day, value: 1, to: thisDay)

        let dayAfterComponents = calendar.dateComponents(Set([Calendar.Component.year, Calendar.Component.month, Calendar.Component.day]), from: dayAfter!)
        XCTAssertEqual(dayAfterComponents.year, 2016)
        XCTAssertEqual(dayAfterComponents.month, 10)
        XCTAssertEqual(dayAfterComponents.day, 5)
    }

    func test_datesNotOnWeekend() {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let mondayInDecember = calendar.date(from: DateComponents(year: 2018, month: 12, day: 10))!
        XCTAssertFalse(calendar.isDateInWeekend(mondayInDecember))
        let tuesdayInNovember = calendar.date(from: DateComponents(year: 2017, month: 11, day: 14))!
        XCTAssertFalse(calendar.isDateInWeekend(tuesdayInNovember))
        let wednesdayInFebruary = calendar.date(from: DateComponents(year: 2016, month: 2, day: 17))!
        XCTAssertFalse(calendar.isDateInWeekend(wednesdayInFebruary))
        let thursdayInOctober = calendar.date(from: DateComponents(year: 2015, month: 10, day: 22))!
        XCTAssertFalse(calendar.isDateInWeekend(thursdayInOctober))
        let fridayInSeptember = calendar.date(from: DateComponents(year: 2014, month: 9, day: 26))!
        XCTAssertFalse(calendar.isDateInWeekend(fridayInSeptember))
    }

    func test_datesOnWeekend() {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let saturdayInJanuary = calendar.date(from: DateComponents(year:2017, month: 1, day: 7))!
        XCTAssertTrue(calendar.isDateInWeekend(saturdayInJanuary))
        let sundayInFebruary = calendar.date(from: DateComponents(year: 2016, month: 2, day: 14))!
        XCTAssertTrue(calendar.isDateInWeekend(sundayInFebruary))
    }

    func test_customMirror() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let calendarMirror = calendar.customMirror

        XCTAssertEqual(calendar.identifier, calendarMirror.descendant("identifier") as? Calendar.Identifier)
        XCTAssertEqual(calendar.locale, calendarMirror.descendant("locale") as? Locale)
        XCTAssertEqual(calendar.timeZone, calendarMirror.descendant("timeZone") as? TimeZone)
        XCTAssertEqual(calendar.firstWeekday, calendarMirror.descendant("firstWeekday") as? Int)
        XCTAssertEqual(calendar.minimumDaysInFirstWeek, calendarMirror.descendant("minimumDaysInFirstWeek") as? Int)
        #endif
    }

    func test_hashing() {
        #if SKIP
        throw XCTSkip("TODO")
        #else
        let calendars: [Calendar] = [
            Calendar.autoupdatingCurrent,
            Calendar(identifier: .buddhist),
            Calendar(identifier: .gregorian),
            Calendar(identifier: .islamic),
            Calendar(identifier: .iso8601),
        ]
        checkHashable(calendars, equalityOracle: { $0 == $1 })

        // autoupdating calendar isn't equal to the current, even though it's
        // likely to be the same.
        let calendars2: [Calendar] = [
            Calendar.autoupdatingCurrent,
            Calendar.current,
        ]
        checkHashable(calendars2, equalityOracle: { $0 == $1 })
        #endif // !SKIP
    }

    func test_dateFromDoesntMutate() throws {
        // Check that date(from:) does not change the timeZone of the calendar
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        df.timeZone = try XCTUnwrap(TimeZone(identifier: "UTC"))

        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        calendar.timeZone = try XCTUnwrap(TimeZone(secondsFromGMT: 0))

        let expectedDescription = calendar.timeZone == TimeZone.current ? "GMT (current)" : "GMT (fixed)"

        let calendarCopy = calendar
        XCTAssertEqual(calendarCopy.timeZone.identifier, "GMT")
//        XCTAssertEqual(calendarCopy.timeZone.description, expectedDescription)

        let dc = try calendarCopy.dateComponents(in: XCTUnwrap(TimeZone(identifier: "America/New_York")), from: XCTUnwrap(df.date(from: "2019-01-01")))
        XCTAssertEqual(calendarCopy.timeZone.identifier, "GMT")
//        XCTAssertEqual(calendarCopy.timeZone.description, expectedDescription)

        let dt = try XCTUnwrap(calendarCopy.date(from: dc))
        XCTAssertEqual(calendarCopy.timeZone.identifier, "GMT")
        XCTAssertEqual(calendarCopy.timeZone, calendar.timeZone)
        XCTAssertEqual(calendarCopy, calendar)
        #if SKIP
        throw XCTSkip("TODO: dateComponents interval calculations")
        #endif
        XCTAssertEqual(dt.description, "2019-01-01 00:00:00 +0000")
//        XCTAssertEqual(calendarCopy.timeZone.description, expectedDescription)
    }

    func test_sr10638() {
        // https://bugs.swift.org/browse/SR-10638
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        XCTAssertGreaterThan(cal.eraSymbols.count, 0)
    }

    func test_nextDate() throws {
        #if SKIP
        throw XCTSkip("TODO: dateComponents nextDate")
        #else
        var calendar = Calendar.current
        calendar.timeZone = try XCTUnwrap(TimeZone(identifier: "US/Pacific"))
        let date_20200101 = try XCTUnwrap(calendar.date(from: DateComponents(year: 2020, month: 01, day: 1)))

        do {
            let expected = try XCTUnwrap(calendar.date(from: DateComponents(year: 2020, month: 01, day: 2, hour: 0)))
            let components = DateComponents(year: 2020, month: 1, day: 2, hour: 0, minute: 0, second: 0)
            let next = calendar.nextDate(after: date_20200101, matching: components, matchingPolicy: .nextTimePreservingSmallerComponents, direction: .forward)
            XCTAssertEqual(next, expected)
        }

        do {
            // SR-13979 - Check nil result when no valid nextDate
            let components = DateComponents(year: 2019, month: 2, day: 1, hour: 0, minute: 0, second: 0)
            let next = calendar.nextDate(after: date_20200101, matching: components, matchingPolicy: .nextTimePreservingSmallerComponents, direction: .forward)
            XCTAssertNil(next)
        }
        #endif // !SKIP
    }

}


