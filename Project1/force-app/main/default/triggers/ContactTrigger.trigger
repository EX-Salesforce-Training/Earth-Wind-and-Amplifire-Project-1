// @author: Zackary Frazier
// @last modified project: Project 1
// @desc: trigger for contact

trigger ContactTrigger on Contact (before insert) {
    ContactTriggerHandler.ensureUniqueEmail(Trigger.new);
}