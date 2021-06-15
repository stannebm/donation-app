export type MandatoryForm = {
  contactNumber: string;
  emailAddress: string;
  fromWhom: string;
  massLanguage: string;
  amount: number;
  offerings: OfferingForm[];
};

export type OfferingForm = {
  typeOfMass:
    | "Special Intention"
    | "Thanksgiving"
    | "Departed Soul"
    | "Donation";
  dates?: string[];
  intention?: string;
  otherIntention?: string;
};
