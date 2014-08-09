//
//  main.m
//  terminder
//
//  Created by Harun Urhan on 22.07.2014.
//  Copyright (c) 2014 Harun Urhan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

void startWithoutArgument();
void createReminderLater(NSString *title, NSString *type, NSString *fromNow);
void createReminderOnDate(NSString *title, NSString *date, NSString *dayTime);
NSString* completeBlanks(NSString *date);

EKEventStore *es;
int main(int argc, const char * argv[])
{

    @autoreleasepool {
        es = [[EKEventStore alloc] init];
        [es requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError *error) {
            if(!granted)
            {
                NSLog(@"No permission to access Reminders!");
                exit(-1);
            }
        }];
        if(argc == 1)
            startWithoutArgument();
        else if(!strcmp(argv[1], "-d"))
            createReminderOnDate([NSString stringWithCString:argv[2] encoding:NSASCIIStringEncoding], [NSString stringWithCString:argv[3] encoding:NSASCIIStringEncoding], [NSString stringWithCString:argv[4] encoding:NSASCIIStringEncoding]);
        else if(!strcmp(argv[1],"-l"))
            createReminderLater([NSString stringWithCString:argv[2] encoding:NSASCIIStringEncoding], [NSString stringWithCString:argv[3] encoding:NSASCIIStringEncoding], [NSString stringWithCString:argv[4] encoding:NSASCIIStringEncoding]);
        else
            NSLog(@"Undefined command, use -l or -d");
    }
    return 0;
}

void createReminderLater(NSString *title, NSString *type, NSString *fromNow)
{
    @autoreleasepool {
        EKReminder *reminder = [EKReminder reminderWithEventStore:es];
        reminder.title = title;
        reminder.calendar = [es defaultCalendarForNewReminders];
        NSInteger duration = [fromNow integerValue];
        if([type  isEqual: @"-m"])
            duration *= 60;
        else if([type isEqual:@"-h"])
            duration *= 3600;
        else if([type isEqual:@"-d"])
            duration *= 86400;
        NSDate *date = [NSDate dateWithTimeIntervalSinceNow:duration]; // after seconds
        EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:date];
        [reminder addAlarm:alarm];
        [es saveReminder:reminder commit:YES error:nil];
        NSLog(@"reminder added after %ld seconds", (long)duration);
    }
}

void createReminderOnDate(NSString *title, NSString *date, NSString *dayTime)
{
    @autoreleasepool {
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"ZZZ"]; // to get user's time zone
        NSString *completeDateStr = [NSString stringWithFormat:@"%@ %@:%@ %@", date, dayTime, @"00", [df stringFromDate:[NSDate date]]]; // date string "yy-mm-dd hh:dd:ss ZZZ"
        EKReminder *reminder = [EKReminder reminderWithEventStore:es];
        reminder.title = title;
        reminder.calendar = [es defaultCalendarForNewReminders];
        NSDate *date = [NSDate dateWithString:completeDateStr];
        EKAlarm *alarm = [EKAlarm alarmWithAbsoluteDate:date];
        [reminder addAlarm:alarm];
        [es saveReminder:reminder commit:YES error:nil];
        NSLog(@"reminder added on %@ %@",date ,dayTime);
    }
}

void startWithoutArgument()
{
    @autoreleasepool {
        NSLog(@"terminder started!, remind <title> <on/later> <date/timespecifier> <daytime/duration>");
        char command[5];
        char type[5];
        char title[256];
        char arg1[8];
        char arg2[8];
        scanf("%s %s %s %s %s",command,title,type,arg1,arg2);
        NSLog(@"command: %s %s %s %s %s",command,title,type,arg1,arg2);
        if(!strcmp(type, "on"))
            createReminderOnDate([NSString stringWithCString:title encoding:NSASCIIStringEncoding], [NSString stringWithCString:arg1 encoding:NSASCIIStringEncoding], [NSString stringWithCString:arg2 encoding:NSASCIIStringEncoding]);
        else if(!strcmp(type,"later"))
            createReminderLater([NSString stringWithCString:title encoding:NSASCIIStringEncoding], [NSString stringWithCString:arg1 encoding:NSASCIIStringEncoding], [NSString stringWithCString:arg2 encoding:NSASCIIStringEncoding]);
        else
        {
            NSLog(@"Undefined type use, 'later' or 'on'");
            exit(-1);
        }
        exit(1);
    }
}



