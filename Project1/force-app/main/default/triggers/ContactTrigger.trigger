// @author: Zackary Frazier
// @created: 7/29/2021
// @desc: trigger for contact

trigger ContactTrigger on Contact (before insert) {
    ContactTriggerHandler.ensureUniqueEmail(Trigger.new);
}