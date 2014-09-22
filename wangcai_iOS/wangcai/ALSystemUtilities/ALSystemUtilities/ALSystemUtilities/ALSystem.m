//
//  ALSystem.m
//  ALSystem
//
//  Created by Andrea Mario Lufino on 09/09/13.
//  Copyright (c) 2013 Andrea Mario Lufino. All rights reserved.
//

#import "ALSystem.h"

@interface NSMutableDictionary (NullProcess)

- (void)setObjectIfNullSetNullString:(id)anObject forKey:(id<NSCopying>)aKey;

@end

@implementation NSMutableDictionary (NullProcess)

- (void)setObjectIfNullSetNullString:(id)anObject forKey:(id<NSCopying>)aKey
{
    if (anObject == nil)
    {
        anObject = @"";
    }
    [self setObject:anObject forKey:aKey];
}

@end

@implementation ALSystem

#pragma mark - All info

+ (NSDictionary *)systemInformations {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    // Battery
    [dictionary setObject:[NSNumber numberWithBool:[ALBattery batteryFullCharged]] forKey:ALBattery_batteryFullCharged];
    [dictionary setObject:[NSNumber numberWithBool:[ALBattery inCharge]] forKey:ALBattery_inCharge];
    [dictionary setObject:[NSNumber numberWithBool:[ALBattery devicePluggedIntoPower]] forKey:ALBattery_devicePluggedIntoPower];
    [dictionary setObject:[NSNumber numberWithInt:[ALBattery batteryState]] forKey:ALBattery_batteryState];
    [dictionary setObject:[NSNumber numberWithFloat:[ALBattery batteryLevel]] forKey:ALBattery_batteryLevel];
    [dictionary setObjectIfNullSetNullString:[ALBattery remainingHoursForStandby] forKey:ALBattery_remainingHoursForStandby];
    [dictionary setObjectIfNullSetNullString:[ALBattery remainingHoursFor3gConversation] forKey:ALBattery_remainingHoursFor3gConversation];
    [dictionary setObjectIfNullSetNullString:[ALBattery remainingHoursFor2gConversation] forKey:ALBattery_remainingHoursFor2gConversation];
    [dictionary setObjectIfNullSetNullString:[ALBattery remainingHoursForInternet3g] forKey:ALBattery_remainingHoursForInternet3g];
    [dictionary setObjectIfNullSetNullString:[ALBattery remainingHoursForInternetWiFi] forKey:ALBattery_remainingHoursForInternetWiFi];
    [dictionary setObjectIfNullSetNullString:[ALBattery remainingHoursForVideo] forKey:ALBattery_remainingHoursForVideo];
    [dictionary setObjectIfNullSetNullString:[ALBattery remainingHoursForAudio] forKey:ALBattery_remainingHoursForAudio];
    // Disk
    [dictionary setObjectIfNullSetNullString:[ALDisk totalDiskSpace] forKey:ALDisk_totalDiskSpace];
    [dictionary setObjectIfNullSetNullString:[ALDisk freeDiskSpace] forKey:ALDisk_freeDiskSpace];
    [dictionary setObjectIfNullSetNullString:[ALDisk usedDiskSpace] forKey:ALDisk_usedDiskSpace];
    [dictionary setObject:[NSNumber numberWithFloat:[ALDisk totalDiskSpaceInBytes]] forKey:ALDisk_totalDiskSpaceInBytes];
    [dictionary setObject:[NSNumber numberWithFloat:[ALDisk freeDiskSpaceInBytes]] forKey:ALDisk_freeDiskSpaceInBytes];
    [dictionary setObject:[NSNumber numberWithFloat:[ALDisk usedDiskSpaceInBytes]] forKey:ALDisk_usedDiskSpaceInBytes];
    // Hardware
    [dictionary setObjectIfNullSetNullString:[ALHardware deviceModel] forKey:ALHardware_deviceModel];
    [dictionary setObjectIfNullSetNullString:[ALHardware deviceName] forKey:ALHardware_deviceName];
    [dictionary setObjectIfNullSetNullString:[ALHardware systemName] forKey:ALHardware_systemName];
    [dictionary setObjectIfNullSetNullString:[ALHardware systemVersion] forKey:ALHardware_systemVersion];
    [dictionary setObject:[NSNumber numberWithFloat:[ALHardware screenWidth]] forKey:ALHardware_screenWidth];
    [dictionary setObject:[NSNumber numberWithFloat:[ALHardware screenHeight]] forKey:ALHardware_screenHeight];
    [dictionary setObject:[NSNumber numberWithFloat:[ALHardware brightness]] forKey:ALHardware_brightness];
    [dictionary setObjectIfNullSetNullString:[ALHardware platformType] forKey:ALHardware_platformType];
    [dictionary setObjectIfNullSetNullString:[ALHardware bootTime] forKey:ALHardware_bootTime];
    [dictionary setObject:[NSNumber numberWithBool:[ALHardware proximitySensor]] forKey:ALHardware_proximitySensor];
    [dictionary setObject:[NSNumber numberWithBool:[ALHardware multitaskingEnabled]] forKey:ALHardware_multitaskingEnabled];
    [dictionary setObjectIfNullSetNullString:[ALHardware sim] forKey:ALHardware_sim];
    [dictionary setObjectIfNullSetNullString:[ALHardware dimensions] forKey:ALHardware_dimensions];
    [dictionary setObjectIfNullSetNullString:[ALHardware weight] forKey:ALHardware_weight];
    [dictionary setObjectIfNullSetNullString:[ALHardware displayType] forKey:ALHardware_displayType];
    [dictionary setObjectIfNullSetNullString:[ALHardware displayDensity] forKey:ALHardware_displayDensity];
    [dictionary setObjectIfNullSetNullString:[ALHardware WLAN] forKey:ALHardware_WLAN];
    [dictionary setObjectIfNullSetNullString:[ALHardware bluetooth] forKey:ALHardware_bluetooth];
    [dictionary setObjectIfNullSetNullString:[ALHardware cameraPrimary] forKey:ALHardware_cameraPrimary];
    [dictionary setObjectIfNullSetNullString:[ALHardware cameraSecondary] forKey:ALHardware_cameraSecondary];
    [dictionary setObjectIfNullSetNullString:[ALHardware cpu] forKey:ALHardware_cpu];
    [dictionary setObjectIfNullSetNullString:[ALHardware gpu] forKey:ALHardware_gpu];
    // Jailbreak
    [dictionary setObject:[NSNumber numberWithBool:[ALJailbreak isJailbroken]] forKey:ALJailbreak_isJailbroken];
    // Localization
    [dictionary setObjectIfNullSetNullString:[ALLocalization language] forKey:ALLocalization_language];
    [dictionary setObjectIfNullSetNullString:[ALLocalization timeZone] forKey:ALLocalization_timeZone];
    [dictionary setObjectIfNullSetNullString:[ALLocalization currencySymbol] forKey:ALLocalization_currencySimbol];
    [dictionary setObjectIfNullSetNullString:[ALLocalization currencyCode] forKey:ALLocalization_currencyCode];
    [dictionary setObjectIfNullSetNullString:[ALLocalization country] forKey:ALLocalization_country];
    [dictionary setObjectIfNullSetNullString:[ALLocalization measurementSystem] forKey:ALLocalization_measurementSystem];
    // Memory
    [dictionary setObject:[NSNumber numberWithInteger:[ALMemory totalMemory]] forKey:ALMemory_totalMemory];
    [dictionary setObject:[NSNumber numberWithFloat:[ALMemory freeMemory]] forKey:ALMemory_freeMemory];
    [dictionary setObject:[NSNumber numberWithFloat:[ALMemory usedMemory]] forKey:ALMemory_usedMemory];
    [dictionary setObject:[NSNumber numberWithFloat:[ALMemory activeMemory]] forKey:ALMemory_activeMemory];
    [dictionary setObject:[NSNumber numberWithFloat:[ALMemory wiredMemory]] forKey:ALMemory_wiredMemory];
    [dictionary setObject:[NSNumber numberWithFloat:[ALMemory inactiveMemory]] forKey:ALMemory_inactivemMemory];
    // Network
    [dictionary setObjectIfNullSetNullString:[ALNetwork currentIPAddress] forKey:ALNetwork_currentIPAddress];
    [dictionary setObject:[NSNumber numberWithBool:[ALNetwork connectedViaWiFi]] forKey:ALNetwork_connectedViaWiFi];
    [dictionary setObject:[NSNumber numberWithBool:[ALNetwork connectedVia3G]] forKey:ALNetwork_connectedVia3G];
    [dictionary setObjectIfNullSetNullString:[ALNetwork macAddress] forKey:ALNetwork_macAddress];
    [dictionary setObjectIfNullSetNullString:@"127.0.0.1" forKey:ALNetwork_externalIPAddress];
    //[dictionary setObjectIfNullSetNullString:[ALNetwork externalIPAddress] forKey:ALNetwork_externalIPAddress];
    [dictionary setObjectIfNullSetNullString:[ALNetwork cellIPAddress] forKey:ALNetwork_cellIPAddress];
    [dictionary setObjectIfNullSetNullString:[ALNetwork WiFiNetmaskAddress] forKey:ALNetwork_WiFiNetmaskAddress];
    [dictionary setObjectIfNullSetNullString:[ALNetwork WiFiBroadcastAddress] forKey:ALNetwork_WiFiBroadcastAddress];
    // Processor
    [dictionary setObject:[NSNumber numberWithInteger:[ALProcessor processorsNumber]] forKey:ALProcessor_processorsNumber];
    [dictionary setObject:[NSNumber numberWithInteger:[ALProcessor activeProcessorsNumber]] forKey:ALProcessor_activeProcessorsNumber];
    [dictionary setObject:[NSNumber numberWithFloat:[ALProcessor cpuUsageForApp]] forKey:ALProcessor_cpuUsageForApp];
    [dictionary setObjectIfNullSetNullString:[ALProcessor activeProcesses] forKey:ALProcessor_activeProcesses];
    [dictionary setObject:[NSNumber numberWithInteger:[ALProcessor numberOfActiveProcesses]] forKey:ALProcessor_numberOfActiveProcesses];
    // Carrier
    [dictionary setObjectIfNullSetNullString:[ALCarrier carrierName] forKey:ALCarrier_carrierName];
    [dictionary setObjectIfNullSetNullString:[ALCarrier carrierISOCountryCode] forKey:ALCarrier_carrierISOCountryCode];
    [dictionary setObjectIfNullSetNullString:[ALCarrier carrierMobileCountryCode] forKey:ALCarrier_carrierMobileCountryCode];
    [dictionary setObjectIfNullSetNullString:[ALCarrier carrierMobileNetworkCode] forKey:ALCarrier_carriermobileNetworkCode];
    [dictionary setObject:[NSNumber numberWithBool:[ALCarrier carrierAllowsVOIP]] forKey:ALCarrier_carrierAllowsVOIP];
    // Accessory
    [dictionary setObject:[NSNumber numberWithBool:[ALAccessory accessoriesPluggedIn]] forKey:ALAccessory_accessoriesPluggedIn];
    [dictionary setObject:[NSNumber numberWithInteger:[ALAccessory numberOfAccessoriesPluggedIn]] forKey:ALAccessory_numberOfAccessoriesPluggedIn];
    [dictionary setObject:[NSNumber numberWithBool:[ALAccessory isHeadphonesAttached]] forKey:ALAccessory_isHeadphonesAttached];
    return dictionary;
}

#pragma mark - Battery

+ (NSDictionary *)batteryInformations {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSNumber numberWithBool:[ALBattery batteryFullCharged]] forKey:ALBattery_batteryFullCharged];
    [dictionary setObject:[NSNumber numberWithBool:[ALBattery inCharge]] forKey:ALBattery_inCharge];
    [dictionary setObject:[NSNumber numberWithBool:[ALBattery devicePluggedIntoPower]] forKey:ALBattery_devicePluggedIntoPower];
    [dictionary setObject:[NSNumber numberWithInt:[ALBattery batteryState]] forKey:ALBattery_batteryState];
    [dictionary setObject:[NSNumber numberWithFloat:[ALBattery batteryLevel]] forKey:ALBattery_batteryLevel];
    [dictionary setObjectIfNullSetNullString:[ALBattery remainingHoursForStandby] forKey:ALBattery_remainingHoursForStandby];
    [dictionary setObjectIfNullSetNullString:[ALBattery remainingHoursFor3gConversation] forKey:ALBattery_remainingHoursFor3gConversation];
    [dictionary setObjectIfNullSetNullString:[ALBattery remainingHoursFor2gConversation] forKey:ALBattery_remainingHoursFor2gConversation];
    [dictionary setObjectIfNullSetNullString:[ALBattery remainingHoursForInternet3g] forKey:ALBattery_remainingHoursForInternet3g];
    [dictionary setObjectIfNullSetNullString:[ALBattery remainingHoursForInternetWiFi] forKey:ALBattery_remainingHoursForInternetWiFi];
    [dictionary setObjectIfNullSetNullString:[ALBattery remainingHoursForVideo] forKey:ALBattery_remainingHoursForVideo];
    [dictionary setObjectIfNullSetNullString:[ALBattery remainingHoursForAudio] forKey:ALBattery_remainingHoursForAudio];
    return dictionary;
}

#pragma mark - Disk

+ (NSDictionary *)diskInformations {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObjectIfNullSetNullString:[ALDisk totalDiskSpace] forKey:ALDisk_totalDiskSpace];
    [dictionary setObjectIfNullSetNullString:[ALDisk freeDiskSpace] forKey:ALDisk_freeDiskSpace];
    [dictionary setObjectIfNullSetNullString:[ALDisk usedDiskSpace] forKey:ALDisk_usedDiskSpace];
    [dictionary setObject:[NSNumber numberWithFloat:[ALDisk totalDiskSpaceInBytes]] forKey:ALDisk_totalDiskSpaceInBytes];
    [dictionary setObject:[NSNumber numberWithFloat:[ALDisk freeDiskSpaceInBytes]] forKey:ALDisk_freeDiskSpaceInBytes];
    [dictionary setObject:[NSNumber numberWithFloat:[ALDisk usedDiskSpaceInBytes]] forKey:ALDisk_usedDiskSpaceInBytes];
    return dictionary;
}

#pragma mark - Hardware

+ (NSDictionary *)hardwareInformations {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObjectIfNullSetNullString:[ALHardware deviceModel] forKey:ALHardware_deviceModel];
    [dictionary setObjectIfNullSetNullString:[ALHardware deviceName] forKey:ALHardware_deviceName];
    [dictionary setObjectIfNullSetNullString:[ALHardware systemName] forKey:ALHardware_systemName];
    [dictionary setObjectIfNullSetNullString:[ALHardware systemVersion] forKey:ALHardware_systemVersion];
    [dictionary setObject:[NSNumber numberWithFloat:[ALHardware screenWidth]] forKey:ALHardware_screenWidth];
    [dictionary setObject:[NSNumber numberWithFloat:[ALHardware screenHeight]] forKey:ALHardware_screenHeight];
    [dictionary setObject:[NSNumber numberWithFloat:[ALHardware brightness]] forKey:ALHardware_brightness];
    [dictionary setObjectIfNullSetNullString:[ALHardware platformType] forKey:ALHardware_platformType];
    [dictionary setObjectIfNullSetNullString:[ALHardware bootTime] forKey:ALHardware_bootTime];
    [dictionary setObject:[NSNumber numberWithBool:[ALHardware proximitySensor]] forKey:ALHardware_proximitySensor];
    [dictionary setObject:[NSNumber numberWithBool:[ALHardware multitaskingEnabled]] forKey:ALHardware_multitaskingEnabled];
    [dictionary setObjectIfNullSetNullString:[ALHardware sim] forKey:ALHardware_sim];
    [dictionary setObjectIfNullSetNullString:[ALHardware dimensions] forKey:ALHardware_dimensions];
    [dictionary setObjectIfNullSetNullString:[ALHardware weight] forKey:ALHardware_weight];
    [dictionary setObjectIfNullSetNullString:[ALHardware displayType] forKey:ALHardware_displayType];
    [dictionary setObjectIfNullSetNullString:[ALHardware displayDensity] forKey:ALHardware_displayDensity];
    [dictionary setObjectIfNullSetNullString:[ALHardware WLAN] forKey:ALHardware_WLAN];
    [dictionary setObjectIfNullSetNullString:[ALHardware bluetooth] forKey:ALHardware_bluetooth];
    [dictionary setObjectIfNullSetNullString:[ALHardware cameraPrimary] forKey:ALHardware_cameraPrimary];
    [dictionary setObjectIfNullSetNullString:[ALHardware cameraSecondary] forKey:ALHardware_cameraSecondary];
    [dictionary setObjectIfNullSetNullString:[ALHardware cpu] forKey:ALHardware_cpu];
    [dictionary setObjectIfNullSetNullString:[ALHardware gpu] forKey:ALHardware_gpu];
    return dictionary;
}

#pragma mark - Jailbreak

+ (NSDictionary *)jailbreakInformations {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSNumber numberWithBool:[ALJailbreak isJailbroken]] forKey:ALJailbreak_isJailbroken];
    return dictionary;
}

#pragma mark - Localization

+ (NSDictionary *)localizationInformations {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObjectIfNullSetNullString:[ALLocalization language] forKey:ALLocalization_language];
    [dictionary setObjectIfNullSetNullString:[ALLocalization timeZone] forKey:ALLocalization_timeZone];
    [dictionary setObjectIfNullSetNullString:[ALLocalization currencySymbol] forKey:ALLocalization_currencySimbol];
    [dictionary setObjectIfNullSetNullString:[ALLocalization currencyCode] forKey:ALLocalization_currencyCode];
    [dictionary setObjectIfNullSetNullString:[ALLocalization country] forKey:ALLocalization_country];
    [dictionary setObjectIfNullSetNullString:[ALLocalization measurementSystem] forKey:ALLocalization_measurementSystem];
    return dictionary;
}

#pragma mark - Memory

+ (NSDictionary *)memoryInformations {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSNumber numberWithInteger:[ALMemory totalMemory]] forKey:ALMemory_totalMemory];
    [dictionary setObject:[NSNumber numberWithFloat:[ALMemory freeMemory]] forKey:ALMemory_freeMemory];
    [dictionary setObject:[NSNumber numberWithFloat:[ALMemory usedMemory]] forKey:ALMemory_usedMemory];
    [dictionary setObject:[NSNumber numberWithFloat:[ALMemory activeMemory]] forKey:ALMemory_activeMemory];
    [dictionary setObject:[NSNumber numberWithFloat:[ALMemory wiredMemory]] forKey:ALMemory_wiredMemory];
    [dictionary setObject:[NSNumber numberWithFloat:[ALMemory inactiveMemory]] forKey:ALMemory_inactivemMemory];
    return dictionary;
}

#pragma mark - Network

+ (NSDictionary *)networkInformations {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObjectIfNullSetNullString:[ALNetwork currentIPAddress] forKey:ALNetwork_currentIPAddress];
    [dictionary setObject:[NSNumber numberWithBool:[ALNetwork connectedViaWiFi]] forKey:ALNetwork_connectedViaWiFi];
    [dictionary setObject:[NSNumber numberWithBool:[ALNetwork connectedVia3G]] forKey:ALNetwork_connectedVia3G];
    [dictionary setObjectIfNullSetNullString:[ALNetwork macAddress] forKey:ALNetwork_macAddress];
    [dictionary setObjectIfNullSetNullString:@"127.0.0.1" forKey:ALNetwork_externalIPAddress];
    //[dictionary setObjectIfNullSetNullString:[ALNetwork externalIPAddress] forKey:ALNetwork_externalIPAddress];
    [dictionary setObjectIfNullSetNullString:[ALNetwork cellIPAddress] forKey:ALNetwork_cellIPAddress];
    [dictionary setObjectIfNullSetNullString:[ALNetwork WiFiNetmaskAddress] forKey:ALNetwork_WiFiNetmaskAddress];
    [dictionary setObjectIfNullSetNullString:[ALNetwork WiFiBroadcastAddress] forKey:ALNetwork_WiFiBroadcastAddress];
    return dictionary;
}

#pragma mark - Processor

+ (NSDictionary *)processorInformations {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSNumber numberWithInteger:[ALProcessor processorsNumber]] forKey:ALProcessor_processorsNumber];
    [dictionary setObject:[NSNumber numberWithInteger:[ALProcessor activeProcessorsNumber]] forKey:ALProcessor_activeProcessorsNumber];
    [dictionary setObject:[NSNumber numberWithFloat:[ALProcessor cpuUsageForApp]] forKey:ALProcessor_cpuUsageForApp];
    [dictionary setObject:[ALProcessor activeProcesses] forKey:ALProcessor_activeProcesses];
    [dictionary setObject:[NSNumber numberWithInteger:[ALProcessor numberOfActiveProcesses]] forKey:ALProcessor_numberOfActiveProcesses];
    return dictionary;
}

#pragma mark - Carrier

+ (NSDictionary *)carrierInformations {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObjectIfNullSetNullString:[ALCarrier carrierName] forKey:ALCarrier_carrierName];
    [dictionary setObjectIfNullSetNullString:[ALCarrier carrierISOCountryCode] forKey:ALCarrier_carrierISOCountryCode];
    [dictionary setObjectIfNullSetNullString:[ALCarrier carrierMobileCountryCode] forKey:ALCarrier_carrierMobileCountryCode];
    [dictionary setObjectIfNullSetNullString:[ALCarrier carrierMobileNetworkCode] forKey:ALCarrier_carriermobileNetworkCode];
    [dictionary setObject:[NSNumber numberWithBool:[ALCarrier carrierAllowsVOIP]] forKey:ALCarrier_carrierAllowsVOIP];
    return dictionary;
}

#pragma mark - Accessory

+ (NSDictionary *)accessoryInformations {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:[NSNumber numberWithBool:[ALAccessory accessoriesPluggedIn]] forKey:ALAccessory_accessoriesPluggedIn];
    [dictionary setObject:[NSNumber numberWithInteger:[ALAccessory numberOfAccessoriesPluggedIn]] forKey:ALAccessory_numberOfAccessoriesPluggedIn];
    [dictionary setObject:[NSNumber numberWithBool:[ALAccessory isHeadphonesAttached]] forKey:ALAccessory_isHeadphonesAttached];
    return dictionary;
}

@end
