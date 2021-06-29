export type OfferingForm = {
  reference_no: string;
  type: "donation" | "mass";
  contact_number: string;
  email: string;
  name: string;
  amount: number;
  mass_language?: string;
  intentions: IntentionForm[];
};

export type IntentionForm = {
  intention?: string;
  dates?: string[];
  type_of_mass:
  | "Special Intention"
  | "Thanksgiving"
  | "Departed Soul"
  other_intention?: string;
};
