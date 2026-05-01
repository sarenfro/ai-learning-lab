-- Migrate 6 sessions from staging (uwfkquukobhvguobirkr) to production
-- created_by set to NULL since the staging user UUID won't exist in production auth.users

INSERT INTO meetings (id, title, description, location, physical_location, start_time, end_time, ics_uid, created_by)
VALUES
  (
    '40d412df-ed56-47a1-b382-d6eb3a91600a',
    'Session 1 - Identifying AI Opportunities',
    $$Location: In Person (PACCAR 390) or Zoom (you pick!)

High-ROI use cases · Prioritization frameworks · Signal vs. hype
Deliverable due next session: Market Research draft$$,
    'https://washington.zoom.us/my/sarenfro',
    'PACCAR 390',
    '2026-04-22 01:30:00+00',
    '2026-04-22 02:30:00+00',
    'ed70b555-cb83-4cce-8c9a-3c70ea868a15',
    NULL
  ),
  (
    '7a843aff-ccd9-4b3b-8c37-102f98461b62',
    'Session 2 - Business Case Development',
    $$Location: Virtual

TAM/SAM/SOM · Cost-benefit modeling · Build vs. buy vs. partner
Due: Market Research (01) · Begin customer interview outreach$$,
    'https://washington.zoom.us/my/sarenfro',
    NULL,
    '2026-04-29 01:30:00+00',
    '2026-04-29 02:30:00+00',
    '15df5d7c-3af5-4f0c-98cb-99f16de5dfad',
    NULL
  ),
  (
    '822025bd-ea8f-458d-8de1-30bd6418bc7b',
    'Session 3 - Customer Discovery & Validation',
    $$// Note: Possible shift to Wed, May 6 - TBD //


Rapid research · Win/loss interviews · ICP definition · Validate demand
Due: Business Case (02) · At least 3 interviews completed$$,
    'https://washington.zoom.us/my/sarenfro',
    NULL,
    '2026-05-05 01:30:00+00',
    '2026-05-05 02:30:00+00',
    'c1ffa475-9d80-4b69-b406-e78c4740dd41',
    NULL
  ),
  (
    '950eb603-4b4a-44cc-97f4-c2dcb9c41426',
    'Session 4 - AI Product Scoping & Prototyping',
    $$// Note: Possible Shift to Wed May 13 - TBD//

Prompt engineering · Tool selection · MVP scoping · Eng handoff
Due: Customer Validation (03) · POC build begins$$,
    'https://washington.zoom.us/my/sarenfro',
    NULL,
    '2026-05-12 01:30:00+00',
    '2026-05-12 02:30:00+00',
    '08f39fe8-e064-4bb8-8588-78942a12fd21',
    NULL
  ),
  (
    '09e79083-42c4-46d9-a0f3-2855f9aec0d6',
    'Session 5 - Go-to-Market Strategy',
    $$// Note: Final Session Date to be Determined later, please hold Mon - Wed just in case //

Cross-functional alignment · Launch sequencing · Pricing · Early adopters
Due: AI POC / MVP (04) · GTM Plan draft ready for review$$,
    'https://washington.zoom.us/my/sarenfro',
    NULL,
    '2026-05-19 01:30:00+00',
    '2026-05-19 02:30:00+00',
    'ba3ac46d-36af-4f3e-874a-086535ec28ab',
    NULL
  ),
  (
    '0c562369-cd91-4265-8834-8b8d043be7e7',
    'Session 6 - Demo Day & Commercialization',
    $$// Note: Date may shift to Wed, May 27 - TBD //

Executive presentations · Measuring success · Next-stage funding
Due: All deliverables (01-06) · Live demo to company leadership$$,
    'https://washington.zoom.us/my/sarenfro',
    NULL,
    '2026-05-27 01:30:00+00',
    '2026-05-27 02:30:00+00',
    '46db427f-f626-4457-bb22-6519c6fa6ad5',
    NULL
  )
ON CONFLICT (id) DO NOTHING;

-- ─── Attendees ───────────────────────────────────────────────────────────────
-- Session 1 (40d412df)
INSERT INTO meeting_attendees (id, meeting_id, name, email, role, added_at) VALUES
  ('056579da-5349-4366-a5a6-5c9e1c754920','40d412df-ed56-47a1-b382-d6eb3a91600a','Russ Mann','russ@speycast.com','co_organizer','2026-04-20 06:10:46.191256+00'),
  ('076f4681-f163-41c8-8111-5904e03144ee','40d412df-ed56-47a1-b382-d6eb3a91600a','Colette Vogel','colettev@uw.edu','co_organizer','2026-04-20 06:10:46.191256+00'),
  ('cf918311-972f-44c0-999e-d782d60f3c65','40d412df-ed56-47a1-b382-d6eb3a91600a','Sarah Renfro','sarenfro@uw.edu','co_organizer','2026-04-20 06:10:46.191256+00'),
  ('de06e71b-ce92-4522-8295-904d363cf044','40d412df-ed56-47a1-b382-d6eb3a91600a','Kesav Bonthu','kesavb@uw.edu','attendee','2026-04-20 06:10:46.191256+00'),
  ('785ea1a7-880a-46fb-8e41-0bdfd9a8f455','40d412df-ed56-47a1-b382-d6eb3a91600a','Sparsh Garg','sparshg9@uw.edu','attendee','2026-04-20 06:10:46.191256+00'),
  ('d39fd13e-1ccb-449f-934f-b504fb101cdd','40d412df-ed56-47a1-b382-d6eb3a91600a','Tanmay Kakati','tkakati@uw.edu','attendee','2026-04-20 06:10:46.191256+00'),
  ('2ca06887-a7ac-41c1-aeb5-4c12e0a27242','40d412df-ed56-47a1-b382-d6eb3a91600a','Rishabh Katare','rkatare@uw.edu','attendee','2026-04-20 06:10:46.191256+00'),
  ('3bd52cef-3022-42ea-ad0b-aac6c7449733','40d412df-ed56-47a1-b382-d6eb3a91600a','Claire Nguyen','hangn2@uw.edu','attendee','2026-04-20 06:10:46.191256+00'),
  ('aeb5a57c-122c-43a0-8855-561c205d4a55','40d412df-ed56-47a1-b382-d6eb3a91600a','Halima Noor','hnoor3@uw.edu','attendee','2026-04-20 06:10:46.191256+00'),
  ('e842b60c-46a4-4c89-8bac-340cd44c62df','40d412df-ed56-47a1-b382-d6eb3a91600a','Benjamin Pitock','bpitock@uw.edu','attendee','2026-04-20 06:10:46.191256+00'),
  ('4f79f2e1-8a4c-425c-a46b-d52a3d63a304','40d412df-ed56-47a1-b382-d6eb3a91600a','Debjyoti Samanta','dsaman@uw.edu','attendee','2026-04-20 06:10:46.191256+00'),
  ('1e8286d6-f105-441b-979f-d79b91409ea8','40d412df-ed56-47a1-b382-d6eb3a91600a','McKenna Joy Tey','mtey2@uw.edu','attendee','2026-04-20 06:10:46.191256+00'),
  ('f3be26f6-9370-4720-b8dc-5184d712573d','40d412df-ed56-47a1-b382-d6eb3a91600a','Jipsa Rao Vankayaka','jipsarao@uw.edu','attendee','2026-04-20 06:10:46.191256+00'),
  ('8da7f1c3-aa17-4d2d-91c1-f076055bc116','40d412df-ed56-47a1-b382-d6eb3a91600a','Yuxi Zhu','yuxiz78@uw.edu','attendee','2026-04-20 06:10:46.191256+00'),
  ('6aef2a63-14c2-49d8-a345-02e40baeaf43','40d412df-ed56-47a1-b382-d6eb3a91600a','Susan Estefany Salinas','susm@uw.edu','attendee','2026-04-20 06:10:46.191256+00'),
  ('378ebb05-a2d2-4be1-9710-90c9d03e3328','40d412df-ed56-47a1-b382-d6eb3a91600a','Shaurya Kumar','kshaurya@uw.edu','attendee','2026-04-20 06:10:46.191256+00'),
  ('dabb17bb-4935-49c0-bd18-776d86c5a41e','40d412df-ed56-47a1-b382-d6eb3a91600a','Soham Mehrota','mohso@uw.edu','attendee','2026-04-20 06:10:46.191256+00'),
  ('27311fe8-2a57-4580-8c4d-0d4135c15b9a','40d412df-ed56-47a1-b382-d6eb3a91600a','Mehak Mittal','memittal@uw.edu','attendee','2026-04-20 06:10:46.191256+00'),
  ('94438641-5aa6-4b4f-ae9e-68c08d85dad9','40d412df-ed56-47a1-b382-d6eb3a91600a','Dipankar Mohanty','dm998@uw.edu','attendee','2026-04-20 06:10:46.191256+00'),
  ('f038e18c-b65b-494e-a8b3-4f93f4913a56','40d412df-ed56-47a1-b382-d6eb3a91600a','Shruti Yadav','shrutiy@uw.edu','attendee','2026-04-20 06:10:46.191256+00'),
  ('643c5e35-a29f-4640-b7e7-3f1f346d5b69','40d412df-ed56-47a1-b382-d6eb3a91600a','Carla Aliaga','caliagav@uw.edu','attendee','2026-04-20 06:10:46.191256+00'),
  ('a9e7176f-7b37-4c4d-8cba-3c3e4758b1d9','40d412df-ed56-47a1-b382-d6eb3a91600a','Corey Zhu','coreyzhu@uw.edu','attendee','2026-04-20 06:10:46.191256+00'),
  ('7b7d5e73-76f5-4efc-b4d3-469957c7f5ab','40d412df-ed56-47a1-b382-d6eb3a91600a','Richard Jean','rjean2@uw.edu','attendee','2026-04-20 06:10:46.191256+00'),
  ('c83148e8-3852-427e-9ac1-91df524a3870','40d412df-ed56-47a1-b382-d6eb3a91600a','Dipen Waghela','dipenw@uw.edu','attendee','2026-04-20 06:10:46.191256+00')
ON CONFLICT (id) DO NOTHING;

-- Session 2 (7a843aff)
INSERT INTO meeting_attendees (id, meeting_id, name, email, role, added_at) VALUES
  ('d1d80eb1-ac3c-4797-90a8-c7c8c3467a96','7a843aff-ccd9-4b3b-8c37-102f98461b62','Russ Mann','russ@speycast.com','co_organizer','2026-04-20 06:13:01.40231+00'),
  ('7b8f6954-a6a8-40ac-9aba-a4192a434808','7a843aff-ccd9-4b3b-8c37-102f98461b62','Colette Vogel','colettev@uw.edu','co_organizer','2026-04-20 06:13:01.40231+00'),
  ('d283d439-16d5-4b12-aa02-25945707e3cf','7a843aff-ccd9-4b3b-8c37-102f98461b62','Sarah Renfro','sarenfro@uw.edu','co_organizer','2026-04-20 06:13:01.40231+00'),
  ('888d60a0-d5c0-4bde-aa56-767c67fbab7d','7a843aff-ccd9-4b3b-8c37-102f98461b62','Kesav Bonthu','kesavb@uw.edu','attendee','2026-04-20 06:13:01.40231+00'),
  ('a408488c-7d07-4c3d-9ee2-c30f7c4cc91c','7a843aff-ccd9-4b3b-8c37-102f98461b62','Sparsh Garg','sparshg9@uw.edu','attendee','2026-04-20 06:13:01.40231+00'),
  ('8c6590cd-0d7d-49fc-a982-4011167de5d3','7a843aff-ccd9-4b3b-8c37-102f98461b62','Tanmay Kakati','tkakati@uw.edu','attendee','2026-04-20 06:13:01.40231+00'),
  ('7a559956-7ea4-4beb-972d-d3412ef38756','7a843aff-ccd9-4b3b-8c37-102f98461b62','Rishabh Katare','rkatare@uw.edu','attendee','2026-04-20 06:13:01.40231+00'),
  ('e504af30-065f-4940-bc92-f9a2c845c46a','7a843aff-ccd9-4b3b-8c37-102f98461b62','Claire Nguyen','hangn2@uw.edu','attendee','2026-04-20 06:13:01.40231+00'),
  ('dd839dd5-d4d8-4954-855b-13af69397dee','7a843aff-ccd9-4b3b-8c37-102f98461b62','Halima Noor','hnoor3@uw.edu','attendee','2026-04-20 06:13:01.40231+00'),
  ('8d6d324a-615c-4d90-883e-a6acdb25d406','7a843aff-ccd9-4b3b-8c37-102f98461b62','Benjamin Pitock','bpitock@uw.edu','attendee','2026-04-20 06:13:01.40231+00'),
  ('23ed8dec-6ac3-41f2-8e7f-2506b2f5539a','7a843aff-ccd9-4b3b-8c37-102f98461b62','Debjyoti Samanta','dsaman@uw.edu','attendee','2026-04-20 06:13:01.40231+00'),
  ('ff67f8a7-9269-464d-9464-ddec156a311c','7a843aff-ccd9-4b3b-8c37-102f98461b62','McKenna Joy Tey','mtey2@uw.edu','attendee','2026-04-20 06:13:01.40231+00'),
  ('3e6d3fea-2a82-4bf1-878e-2add2bfbb37c','7a843aff-ccd9-4b3b-8c37-102f98461b62','Jipsa Rao Vankayaka','jipsarao@uw.edu','attendee','2026-04-20 06:13:01.40231+00'),
  ('82fd4dad-8fdb-43a9-8e1c-adb2c4e82be6','7a843aff-ccd9-4b3b-8c37-102f98461b62','Yuxi Zhu','yuxiz78@uw.edu','attendee','2026-04-20 06:13:01.40231+00'),
  ('c8fb3345-9e6a-4737-9122-76b23cc84824','7a843aff-ccd9-4b3b-8c37-102f98461b62','Susan Estefany Salinas','susm@uw.edu','attendee','2026-04-20 06:13:01.40231+00'),
  ('980bc589-57a7-4d28-86a1-9020e0ad5804','7a843aff-ccd9-4b3b-8c37-102f98461b62','Shaurya Kumar','kshaurya@uw.edu','attendee','2026-04-20 06:13:01.40231+00'),
  ('c143f5bb-74b5-490b-ba16-a5733b8fc74b','7a843aff-ccd9-4b3b-8c37-102f98461b62','Soham Mehrota','mohso@uw.edu','attendee','2026-04-20 06:13:01.40231+00'),
  ('b38116bf-38ca-4470-a86d-5a334914e460','7a843aff-ccd9-4b3b-8c37-102f98461b62','Mehak Mittal','memittal@uw.edu','attendee','2026-04-20 06:13:01.40231+00'),
  ('b6b0967c-35f6-4063-a52d-8c5f59149ac1','7a843aff-ccd9-4b3b-8c37-102f98461b62','Dipankar Mohanty','dm998@uw.edu','attendee','2026-04-20 06:13:01.40231+00'),
  ('3b662130-c946-41bb-b5ae-7dddcdcaf33b','7a843aff-ccd9-4b3b-8c37-102f98461b62','Shruti Yadav','shrutiy@uw.edu','attendee','2026-04-20 06:13:01.40231+00'),
  ('e680899d-d7fc-486c-bf06-d538fbf027b8','7a843aff-ccd9-4b3b-8c37-102f98461b62','Carla Aliaga','caliagav@uw.edu','attendee','2026-04-20 06:13:01.40231+00'),
  ('95bb0881-7d50-4e3f-9ae7-ea1b327528d2','7a843aff-ccd9-4b3b-8c37-102f98461b62','Dipen Waghela','dipenw@uw.edu','attendee','2026-04-20 06:13:01.40231+00'),
  ('bde2f8bc-0a00-4619-887d-3d44358f5dea','7a843aff-ccd9-4b3b-8c37-102f98461b62','Corey Zhu','coreyzhu@uw.edu','attendee','2026-04-20 06:13:01.40231+00'),
  ('02f69cd2-7b55-4272-963c-c5f57b69435f','7a843aff-ccd9-4b3b-8c37-102f98461b62','Richard Jean','rjean2@uw.edu','attendee','2026-04-20 06:13:01.40231+00')
ON CONFLICT (id) DO NOTHING;

-- Session 3 (822025bd)
INSERT INTO meeting_attendees (id, meeting_id, name, email, role, added_at) VALUES
  ('e9f09a75-d855-470e-87a2-cdbaa89b06a2','822025bd-ea8f-458d-8de1-30bd6418bc7b','Sarah Renfro','sarenfro@uw.edu','co_organizer','2026-04-20 06:17:43.847733+00'),
  ('b8845bd0-76d0-475d-94fe-02c351366f16','822025bd-ea8f-458d-8de1-30bd6418bc7b','Colette Vogel','colettev@uw.edu','co_organizer','2026-04-20 06:17:43.847733+00'),
  ('60f9aa58-c326-4fd9-98b5-65048e91ae6b','822025bd-ea8f-458d-8de1-30bd6418bc7b','Russ Mann','russ@speycast.com','co_organizer','2026-04-20 06:17:43.847733+00'),
  ('53454076-7dcb-47d1-8ad7-02b8b0eeb65a','822025bd-ea8f-458d-8de1-30bd6418bc7b','Dipen Waghela','dipenw@uw.edu','attendee','2026-04-20 06:17:43.847733+00'),
  ('71fc54ec-dde7-412a-abd1-55a43c0ca64e','822025bd-ea8f-458d-8de1-30bd6418bc7b','Richard Jean','rjean2@uw.edu','attendee','2026-04-20 06:17:43.847733+00'),
  ('406f6d61-e724-4a5c-8105-83e0a1671e8f','822025bd-ea8f-458d-8de1-30bd6418bc7b','Corey Zhu','coreyzhu@uw.edu','attendee','2026-04-20 06:17:43.847733+00'),
  ('03cb9066-30f8-46be-ab3f-1542c8144791','822025bd-ea8f-458d-8de1-30bd6418bc7b','Carla Aliaga','caliagav@uw.edu','attendee','2026-04-20 06:17:43.847733+00'),
  ('1125d1f3-f9bc-456a-9068-2d9609e24599','822025bd-ea8f-458d-8de1-30bd6418bc7b','Shruti Yadav','shrutiy@uw.edu','attendee','2026-04-20 06:17:43.847733+00'),
  ('90af1596-9129-4c4c-8741-1208ee831445','822025bd-ea8f-458d-8de1-30bd6418bc7b','Dipankar Mohanty','dm998@uw.edu','attendee','2026-04-20 06:17:43.847733+00'),
  ('b0ce3c71-a5ba-49b3-96f9-00940f262735','822025bd-ea8f-458d-8de1-30bd6418bc7b','Mehak Mittal','memittal@uw.edu','attendee','2026-04-20 06:17:43.847733+00'),
  ('e68b71fd-d83e-4f7b-8d10-43d2d0e53a73','822025bd-ea8f-458d-8de1-30bd6418bc7b','Soham Mehrota','mohso@uw.edu','attendee','2026-04-20 06:17:43.847733+00'),
  ('2bb55118-a447-4388-825b-f5a76686aa4f','822025bd-ea8f-458d-8de1-30bd6418bc7b','Shaurya Kumar','kshaurya@uw.edu','attendee','2026-04-20 06:17:43.847733+00'),
  ('2a9e541f-1af4-4554-a1b3-d0510a73d25c','822025bd-ea8f-458d-8de1-30bd6418bc7b','Susan Estefany Salinas','susm@uw.edu','attendee','2026-04-20 06:17:43.847733+00'),
  ('c066e7af-365e-4883-9bd5-1526f4a75e01','822025bd-ea8f-458d-8de1-30bd6418bc7b','Yuxi Zhu','yuxiz78@uw.edu','attendee','2026-04-20 06:17:43.847733+00'),
  ('7a319875-228c-421c-ae86-a8052ba76291','822025bd-ea8f-458d-8de1-30bd6418bc7b','Jipsa Rao Vankayaka','jipsarao@uw.edu','attendee','2026-04-20 06:17:43.847733+00'),
  ('ce55cf29-bc62-436d-b3e9-1ee02ed5bce5','822025bd-ea8f-458d-8de1-30bd6418bc7b','McKenna Joy Tey','mtey2@uw.edu','attendee','2026-04-20 06:17:43.847733+00'),
  ('c4f5e4c6-e139-49e3-8689-855b0ba7f525','822025bd-ea8f-458d-8de1-30bd6418bc7b','Debjyoti Samanta','dsaman@uw.edu','attendee','2026-04-20 06:17:43.847733+00'),
  ('6f3319cf-be37-4d1a-b846-18637c271d97','822025bd-ea8f-458d-8de1-30bd6418bc7b','Benjamin Pitock','bpitock@uw.edu','attendee','2026-04-20 06:17:43.847733+00'),
  ('d9a4c1cd-c50c-4418-b938-1e0618b26d55','822025bd-ea8f-458d-8de1-30bd6418bc7b','Halima Noor','hnoor3@uw.edu','attendee','2026-04-20 06:17:43.847733+00'),
  ('f38da922-7063-409b-aa84-bfb845ac8840','822025bd-ea8f-458d-8de1-30bd6418bc7b','Claire Nguyen','hangn2@uw.edu','attendee','2026-04-20 06:17:43.847733+00'),
  ('d1a62f4e-ce14-4ba1-bf77-534485341b3e','822025bd-ea8f-458d-8de1-30bd6418bc7b','Rishabh Katare','rkatare@uw.edu','attendee','2026-04-20 06:17:43.847733+00'),
  ('4e1c9daa-1c2d-4cc4-a1dd-61dbcbb40bcf','822025bd-ea8f-458d-8de1-30bd6418bc7b','Tanmay Kakati','tkakati@uw.edu','attendee','2026-04-20 06:17:43.847733+00'),
  ('c4ba57b5-75a0-43ff-8296-43e384e3ddb8','822025bd-ea8f-458d-8de1-30bd6418bc7b','Sparsh Garg','sparshg9@uw.edu','attendee','2026-04-20 06:17:43.847733+00'),
  ('5646555e-8063-48a9-8212-f032f119fb22','822025bd-ea8f-458d-8de1-30bd6418bc7b','Kesav Bonthu','kesavb@uw.edu','attendee','2026-04-20 06:17:43.847733+00')
ON CONFLICT (id) DO NOTHING;

-- Session 4 (950eb603)
INSERT INTO meeting_attendees (id, meeting_id, name, email, role, added_at) VALUES
  ('63cac06f-df1b-415a-8b95-86f3c904ccff','950eb603-4b4a-44cc-97f4-c2dcb9c41426','Russ Mann','russ@speycast.com','co_organizer','2026-04-20 06:18:40.140081+00'),
  ('49a78820-9acf-4000-9476-afa882666e2d','950eb603-4b4a-44cc-97f4-c2dcb9c41426','Sarah Renfro','sarenfro@uw.edu','co_organizer','2026-04-20 06:18:40.140081+00'),
  ('d1b95474-87d1-47a4-b7c8-27fc676aad0f','950eb603-4b4a-44cc-97f4-c2dcb9c41426','Colette Vogel','colettev@uw.edu','co_organizer','2026-04-20 06:18:40.140081+00'),
  ('757b3fba-4d06-4b71-9912-cbb5d0054c47','950eb603-4b4a-44cc-97f4-c2dcb9c41426','Dipen Waghela','dipenw@uw.edu','attendee','2026-04-20 06:18:40.140081+00'),
  ('81a514fe-f932-4731-b9ab-37ac9edc582b','950eb603-4b4a-44cc-97f4-c2dcb9c41426','Richard Jean','rjean2@uw.edu','attendee','2026-04-20 06:18:40.140081+00'),
  ('c074457e-08b6-442b-bb78-f28d2708e6a4','950eb603-4b4a-44cc-97f4-c2dcb9c41426','Corey Zhu','coreyzhu@uw.edu','attendee','2026-04-20 06:18:40.140081+00'),
  ('9086b458-8449-4e4b-ae2e-ef74e974795f','950eb603-4b4a-44cc-97f4-c2dcb9c41426','Carla Aliaga','caliagav@uw.edu','attendee','2026-04-20 06:18:40.140081+00'),
  ('9ccc4265-d40a-4ebc-89cf-a3a300526f8c','950eb603-4b4a-44cc-97f4-c2dcb9c41426','Shruti Yadav','shrutiy@uw.edu','attendee','2026-04-20 06:18:40.140081+00'),
  ('018ab8e5-c075-4ffe-a97a-b27521fe4c01','950eb603-4b4a-44cc-97f4-c2dcb9c41426','Dipankar Mohanty','dm998@uw.edu','attendee','2026-04-20 06:18:40.140081+00'),
  ('21f2d43c-deb4-4f6e-a485-60c52085515f','950eb603-4b4a-44cc-97f4-c2dcb9c41426','Mehak Mittal','memittal@uw.edu','attendee','2026-04-20 06:18:40.140081+00'),
  ('66d15775-3ba3-430b-9081-d598f553046f','950eb603-4b4a-44cc-97f4-c2dcb9c41426','Soham Mehrota','mohso@uw.edu','attendee','2026-04-20 06:18:40.140081+00'),
  ('f93089db-d611-435f-995c-303178c40236','950eb603-4b4a-44cc-97f4-c2dcb9c41426','Shaurya Kumar','kshaurya@uw.edu','attendee','2026-04-20 06:18:40.140081+00'),
  ('412bc51d-33aa-47f3-a911-20d265795f3a','950eb603-4b4a-44cc-97f4-c2dcb9c41426','Susan Estefany Salinas','susm@uw.edu','attendee','2026-04-20 06:18:40.140081+00'),
  ('5388efee-f513-401c-a641-3dcba7f1f0be','950eb603-4b4a-44cc-97f4-c2dcb9c41426','Yuxi Zhu','yuxiz78@uw.edu','attendee','2026-04-20 06:18:40.140081+00'),
  ('38533005-6fd0-4fe7-9c8a-33d84a8fda8f','950eb603-4b4a-44cc-97f4-c2dcb9c41426','Jipsa Rao Vankayaka','jipsarao@uw.edu','attendee','2026-04-20 06:18:40.140081+00'),
  ('4e70d033-7da8-46ce-be08-68b217d4092a','950eb603-4b4a-44cc-97f4-c2dcb9c41426','McKenna Joy Tey','mtey2@uw.edu','attendee','2026-04-20 06:18:40.140081+00'),
  ('1dab554c-b749-44d2-bffe-e4859ad1d54a','950eb603-4b4a-44cc-97f4-c2dcb9c41426','Debjyoti Samanta','dsaman@uw.edu','attendee','2026-04-20 06:18:40.140081+00'),
  ('879b8ea7-b0fa-41a1-9d7c-2bfca525d9e8','950eb603-4b4a-44cc-97f4-c2dcb9c41426','Benjamin Pitock','bpitock@uw.edu','attendee','2026-04-20 06:18:40.140081+00'),
  ('a05f8cff-50c8-4414-88ed-8d88701d7ecc','950eb603-4b4a-44cc-97f4-c2dcb9c41426','Halima Noor','hnoor3@uw.edu','attendee','2026-04-20 06:18:40.140081+00'),
  ('c22bb9b0-eed0-4b0c-95a5-7a1da451ddcc','950eb603-4b4a-44cc-97f4-c2dcb9c41426','Claire Nguyen','hangn2@uw.edu','attendee','2026-04-20 06:18:40.140081+00'),
  ('cb4c1750-75ed-4a82-8646-7dfc3055ff98','950eb603-4b4a-44cc-97f4-c2dcb9c41426','Rishabh Katare','rkatare@uw.edu','attendee','2026-04-20 06:18:40.140081+00'),
  ('25f629eb-ea51-423b-ad3f-23ca56d68260','950eb603-4b4a-44cc-97f4-c2dcb9c41426','Tanmay Kakati','tkakati@uw.edu','attendee','2026-04-20 06:18:40.140081+00'),
  ('13a2a910-bdd3-4833-bdc3-7ad77e8392bf','950eb603-4b4a-44cc-97f4-c2dcb9c41426','Sparsh Garg','sparshg9@uw.edu','attendee','2026-04-20 06:18:40.140081+00'),
  ('8bba055a-122d-49ed-bae4-55ddd4051dd0','950eb603-4b4a-44cc-97f4-c2dcb9c41426','Kesav Bonthu','kesavb@uw.edu','attendee','2026-04-20 06:18:40.140081+00')
ON CONFLICT (id) DO NOTHING;

-- Session 5 (09e79083)
INSERT INTO meeting_attendees (id, meeting_id, name, email, role, added_at) VALUES
  ('eee64e69-4cf5-440e-8d15-828d24c39e23','09e79083-42c4-46d9-a0f3-2855f9aec0d6','Sarah Renfro','sarenfro@uw.edu','co_organizer','2026-04-20 06:19:52.424575+00'),
  ('d5740906-8d3e-40a5-a2f9-34de39f6193a','09e79083-42c4-46d9-a0f3-2855f9aec0d6','Colette Vogel','colettev@uw.edu','co_organizer','2026-04-20 06:19:52.424575+00'),
  ('10c26787-a72d-4745-9dd6-b83a27389103','09e79083-42c4-46d9-a0f3-2855f9aec0d6','Russ Mann','russ@speycast.com','co_organizer','2026-04-20 06:19:52.424575+00'),
  ('1e552ac2-504b-417c-b38b-53cc6f4be942','09e79083-42c4-46d9-a0f3-2855f9aec0d6','Dipen Waghela','dipenw@uw.edu','attendee','2026-04-20 06:19:52.424575+00'),
  ('58d30c83-a1ae-4879-b35d-5d546225c23e','09e79083-42c4-46d9-a0f3-2855f9aec0d6','Richard Jean','rjean2@uw.edu','attendee','2026-04-20 06:19:52.424575+00'),
  ('93d3d08e-20e6-4888-bcd3-ccf23517ec74','09e79083-42c4-46d9-a0f3-2855f9aec0d6','Corey Zhu','coreyzhu@uw.edu','attendee','2026-04-20 06:19:52.424575+00'),
  ('f6e2891c-1bb1-4bf8-8787-8856e4aaa142','09e79083-42c4-46d9-a0f3-2855f9aec0d6','Carla Aliaga','caliagav@uw.edu','attendee','2026-04-20 06:19:52.424575+00'),
  ('1b19357c-45be-4020-ad14-f9bf9a8d8064','09e79083-42c4-46d9-a0f3-2855f9aec0d6','Shruti Yadav','shrutiy@uw.edu','attendee','2026-04-20 06:19:52.424575+00'),
  ('39fa60c4-e484-4e77-a3d9-b28a6ca5d5d9','09e79083-42c4-46d9-a0f3-2855f9aec0d6','Dipankar Mohanty','dm998@uw.edu','attendee','2026-04-20 06:19:52.424575+00'),
  ('c7e2620b-5dcd-4031-b86d-303cd5498352','09e79083-42c4-46d9-a0f3-2855f9aec0d6','Mehak Mittal','memittal@uw.edu','attendee','2026-04-20 06:19:52.424575+00'),
  ('a389be88-959a-4365-a9cd-249448ce973c','09e79083-42c4-46d9-a0f3-2855f9aec0d6','Soham Mehrota','mohso@uw.edu','attendee','2026-04-20 06:19:52.424575+00'),
  ('c1913c79-cd68-4f8a-b408-e6dab74df55d','09e79083-42c4-46d9-a0f3-2855f9aec0d6','Shaurya Kumar','kshaurya@uw.edu','attendee','2026-04-20 06:19:52.424575+00'),
  ('7fe4a128-4093-4ac1-b1b5-4833fdc3371a','09e79083-42c4-46d9-a0f3-2855f9aec0d6','Susan Estefany Salinas','susm@uw.edu','attendee','2026-04-20 06:19:52.424575+00'),
  ('830ffbad-aa8d-4b7b-9be4-a2b0d32dce6b','09e79083-42c4-46d9-a0f3-2855f9aec0d6','Yuxi Zhu','yuxiz78@uw.edu','attendee','2026-04-20 06:19:52.424575+00'),
  ('96240b00-cd9b-4dc9-a80c-9d938cff372f','09e79083-42c4-46d9-a0f3-2855f9aec0d6','Jipsa Rao Vankayaka','jipsarao@uw.edu','attendee','2026-04-20 06:19:52.424575+00'),
  ('b4411e7e-1cdb-4f97-a05a-03514ccc8903','09e79083-42c4-46d9-a0f3-2855f9aec0d6','McKenna Joy Tey','mtey2@uw.edu','attendee','2026-04-20 06:19:52.424575+00'),
  ('b0ae9f08-aeb5-4b97-a8e0-73315fb5c255','09e79083-42c4-46d9-a0f3-2855f9aec0d6','Debjyoti Samanta','dsaman@uw.edu','attendee','2026-04-20 06:19:52.424575+00'),
  ('6e83228a-f4cf-4413-8187-566aa142814b','09e79083-42c4-46d9-a0f3-2855f9aec0d6','Benjamin Pitock','bpitock@uw.edu','attendee','2026-04-20 06:19:52.424575+00'),
  ('d1cbe754-d53d-46a3-9d56-b486eb81d985','09e79083-42c4-46d9-a0f3-2855f9aec0d6','Halima Noor','hnoor3@uw.edu','attendee','2026-04-20 06:19:52.424575+00'),
  ('7294e26d-22c0-47f4-8181-5383274f036f','09e79083-42c4-46d9-a0f3-2855f9aec0d6','Claire Nguyen','hangn2@uw.edu','attendee','2026-04-20 06:19:52.424575+00'),
  ('08cfed18-8f14-4421-9f1e-d4408121637a','09e79083-42c4-46d9-a0f3-2855f9aec0d6','Rishabh Katare','rkatare@uw.edu','attendee','2026-04-20 06:19:52.424575+00'),
  ('3202d99c-fb84-402b-8e92-5eb5ee5bb1ba','09e79083-42c4-46d9-a0f3-2855f9aec0d6','Tanmay Kakati','tkakati@uw.edu','attendee','2026-04-20 06:19:52.424575+00'),
  ('99e45a3a-7931-4404-9621-f45a1f0d9e8f','09e79083-42c4-46d9-a0f3-2855f9aec0d6','Sparsh Garg','sparshg9@uw.edu','attendee','2026-04-20 06:19:52.424575+00'),
  ('b67efa29-4487-4f07-987a-9a5eac7c387c','09e79083-42c4-46d9-a0f3-2855f9aec0d6','Kesav Bonthu','kesavb@uw.edu','attendee','2026-04-20 06:19:52.424575+00')
ON CONFLICT (id) DO NOTHING;

-- Session 6 (0c562369)
INSERT INTO meeting_attendees (id, meeting_id, name, email, role, added_at) VALUES
  ('1fc517d3-0699-4c84-9a9d-5ebdbd666b0c','0c562369-cd91-4265-8834-8b8d043be7e7','Sarah Renfro','sarenfro@uw.edu','co_organizer','2026-04-20 06:20:48.120644+00'),
  ('9246086b-2b65-4502-b35d-878dcf5ca8f1','0c562369-cd91-4265-8834-8b8d043be7e7','Colette Vogel','colettev@uw.edu','co_organizer','2026-04-20 06:20:48.120644+00'),
  ('64b4819b-57c0-43d5-98c8-7934ccf9c624','0c562369-cd91-4265-8834-8b8d043be7e7','Russ Mann','russ@speycast.com','co_organizer','2026-04-20 06:20:48.120644+00'),
  ('be02265b-9e0a-4633-9f35-673cf1fbb991','0c562369-cd91-4265-8834-8b8d043be7e7','Dipen Waghela','dipenw@uw.edu','attendee','2026-04-20 06:20:48.120644+00'),
  ('e1977dc3-6c7b-4a56-901e-2a3d35b5f2e5','0c562369-cd91-4265-8834-8b8d043be7e7','Richard Jean','rjean2@uw.edu','attendee','2026-04-20 06:20:48.120644+00'),
  ('72483037-244b-4398-91e6-90dd69bdc4f3','0c562369-cd91-4265-8834-8b8d043be7e7','Corey Zhu','coreyzhu@uw.edu','attendee','2026-04-20 06:20:48.120644+00'),
  ('4ae09007-1fd5-42c2-a997-5f695f06a60f','0c562369-cd91-4265-8834-8b8d043be7e7','Carla Aliaga','caliagav@uw.edu','attendee','2026-04-20 06:20:48.120644+00'),
  ('313bf818-d162-4573-8859-bebed6afa8b0','0c562369-cd91-4265-8834-8b8d043be7e7','Shruti Yadav','shrutiy@uw.edu','attendee','2026-04-20 06:20:48.120644+00'),
  ('2283cb83-3158-4835-9688-264cc4ca3af4','0c562369-cd91-4265-8834-8b8d043be7e7','Dipankar Mohanty','dm998@uw.edu','attendee','2026-04-20 06:20:48.120644+00'),
  ('9c2ca604-d714-4d17-a9c5-08b5a8a837c1','0c562369-cd91-4265-8834-8b8d043be7e7','Mehak Mittal','memittal@uw.edu','attendee','2026-04-20 06:20:48.120644+00'),
  ('df2ef315-cd5f-4210-b3ca-89f51d4d16ef','0c562369-cd91-4265-8834-8b8d043be7e7','Soham Mehrota','mohso@uw.edu','attendee','2026-04-20 06:20:48.120644+00'),
  ('815ee26d-769b-48c2-9d93-d6b4aa427b14','0c562369-cd91-4265-8834-8b8d043be7e7','Shaurya Kumar','kshaurya@uw.edu','attendee','2026-04-20 06:20:48.120644+00'),
  ('34daf708-48f8-4238-9af9-b5138589f8b2','0c562369-cd91-4265-8834-8b8d043be7e7','Susan Estefany Salinas','susm@uw.edu','attendee','2026-04-20 06:20:48.120644+00'),
  ('335deee8-cfc4-4691-af98-205a5c9fa0a4','0c562369-cd91-4265-8834-8b8d043be7e7','Yuxi Zhu','yuxiz78@uw.edu','attendee','2026-04-20 06:20:48.120644+00'),
  ('3d091a2c-9c8e-4a65-8b3f-c58e3bed8148','0c562369-cd91-4265-8834-8b8d043be7e7','Jipsa Rao Vankayaka','jipsarao@uw.edu','attendee','2026-04-20 06:20:48.120644+00'),
  ('8b715ae2-cb73-491b-a464-c41be9a87ea9','0c562369-cd91-4265-8834-8b8d043be7e7','McKenna Joy Tey','mtey2@uw.edu','attendee','2026-04-20 06:20:48.120644+00'),
  ('58531b01-db9f-4b15-8832-7d936e03cab3','0c562369-cd91-4265-8834-8b8d043be7e7','Debjyoti Samanta','dsaman@uw.edu','attendee','2026-04-20 06:20:48.120644+00'),
  ('77fb2475-51f0-4192-b286-ee5d38b54d2b','0c562369-cd91-4265-8834-8b8d043be7e7','Benjamin Pitock','bpitock@uw.edu','attendee','2026-04-20 06:20:48.120644+00'),
  ('23df6a34-7e0e-4112-aaf6-b47a854c92d9','0c562369-cd91-4265-8834-8b8d043be7e7','Halima Noor','hnoor3@uw.edu','attendee','2026-04-20 06:20:48.120644+00'),
  ('9740bd0f-16e8-4ac5-b2d1-ca0f530688da','0c562369-cd91-4265-8834-8b8d043be7e7','Claire Nguyen','hangn2@uw.edu','attendee','2026-04-20 06:20:48.120644+00'),
  ('b81c6967-df17-40c2-a329-8e14a6afc4e8','0c562369-cd91-4265-8834-8b8d043be7e7','Rishabh Katare','rkatare@uw.edu','attendee','2026-04-20 06:20:48.120644+00'),
  ('7576cc5f-e4ea-4e0d-8de7-dfddc0045577','0c562369-cd91-4265-8834-8b8d043be7e7','Tanmay Kakati','tkakati@uw.edu','attendee','2026-04-20 06:20:48.120644+00'),
  ('6a953f99-04b4-4eaf-a2e0-ea5b88a4f970','0c562369-cd91-4265-8834-8b8d043be7e7','Sparsh Garg','sparshg9@uw.edu','attendee','2026-04-20 06:20:48.120644+00'),
  ('d6e9826a-2b0e-400f-88c3-76479cf09316','0c562369-cd91-4265-8834-8b8d043be7e7','Kesav Bonthu','kesavb@uw.edu','attendee','2026-04-20 06:20:48.120644+00')
ON CONFLICT (id) DO NOTHING;
