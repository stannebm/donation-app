import { Box, Button, HStack, VStack } from "@chakra-ui/react";
import axios from "axios";
import React from "react";
import { useForm } from "react-hook-form";
import FormInput from "../elements/form_input";
import FormSelect from "../elements/form_select";

export type DonationForm = {
  reference_no: string;
  contact_number: string;
  email: string;
  name: string;
  amount: number;
  payment_method: string;
  intention: string;
  other_intention?: string;
};

const FORM_TYPE = "donation"
const API_PATH = "/api/donation_form";

export default function Donation() {
  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting },
    watch,
  } = useForm<DonationForm>({
    defaultValues: {
    },
  });

  const onSubmit = (payment_method: "fpx" | "cybersource") => (data: DonationForm) => {
    const submission = { ...data };
    const finalized_intention = submission.intention === "Others" ? submission.other_intention : submission.intention;
    delete submission['other_intention'];
    const submissionPayload = {
      [FORM_TYPE]: { ...submission, reference_no: new Date().getTime(), intention: finalized_intention, payment_method }
    };
    console.log("DEBUG submission", submissionPayload);
    axios
      .post(API_PATH, submissionPayload)
      .then(function({ data }) {
        console.log("posted resp:", data);
      })
      .catch(function(error) {
        console.log(error);
      });
  };

  const intention = watch("intention");

  return (
    <form>
      <HStack mb={3} align="flex-start">
        <FormInput
          label="Name"
          errors={errors}
          {...register("name", { required: true })}
        />
        <FormInput
          label="Contact H/P"
          errors={errors}
          {...register("contact_number", { required: true })}
        />
      </HStack>
      <HStack mb={3} align="flex-start">
        <FormInput
          label="Email"
          errors={errors}
          {...register("email", {
            required: true,
            pattern: {
              value: /^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}$/i,
              message: "Invalid email address",
            },
          })}
        />
      </HStack>
      <HStack mb={3} align="flex-start">
        <FormInput
          label="Donation Amount (RM)"
          errors={errors}
          type="number"
          step="0.01"
          {...register("amount", {
            required: true,
          })}
        />
      </HStack>

      <Box mb={5} p={3} bg="gray.100">
        <VStack>
          <>
            <FormSelect
              label="Intention"
              options={[
                "For Minor Basilica St. Anne",
                "For the Poor or Sick",
                "Others",
              ]}
              bg="white"
              errors={errors}
              {...register("intention", {
                required: true,
              })}
            />
            {intention === "Others" && (
              <FormInput
                label="Other Intention"
                errors={errors}
                {...register(
                  "other_intention",
                  {
                    required: false,
                  },
                )}
              />
            )}
          </>
        </VStack>
      </Box>

      <HStack>
        <Button colorScheme="teal" isLoading={isSubmitting} onClick={(e) => {
          handleSubmit(onSubmit("fpx"))()
          e.preventDefault()
        }}>
          Online Banking
        </Button>

        <Button colorScheme="teal" isLoading={isSubmitting} onClick={(e) => {
          handleSubmit(onSubmit("cybersource"))()
          e.preventDefault()
        }}>
          Credit/Debit Card
        </Button>
      </HStack>
    </form>
  );
}
