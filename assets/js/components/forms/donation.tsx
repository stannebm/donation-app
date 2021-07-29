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

const FORM_TYPE = "donation";
const API_PATH = "/api/donation_form";
const FPX_URL = "https://fpx.minorbasilicastannebm.com/fpx";
const CYBERSOURCE_URL =
  "https://cybersource.minorbasilicastannebm.com/cybersource";

type PaymentLinkParams = {
  paymentMethod: string;
  referenceNo: number;
  amount: number;
  name: string;
  email: string;
};

const mkPaymentUrl = ({
  paymentMethod,
  referenceNo,
  amount,
  name,
  email,
}: PaymentLinkParams) => {
  const path = paymentMethod === "fpx" ? FPX_URL : CYBERSOURCE_URL;
  return `${path}?reference_no=${referenceNo}&amount=${amount}&name=${name}&email=${email}`;
};

export default function Donation() {
  const {
    register,
    handleSubmit,
    formState: { errors, isSubmitting },
    watch,
  } = useForm<DonationForm>({
    defaultValues: {},
  });

  const onSubmit =
    (paymentMethod: "fpx" | "cybersource") => (data: DonationForm) => {
      const submission = { ...data };
      const finalizedIntention =
        submission.intention === "Others"
          ? submission.other_intention
          : submission.intention;
      delete submission["other_intention"];
      const referenceNo = new Date().getTime();
      const amount = submission["amount"];
      const email = submission["email"];
      const name = submission["name"];
      const submissionPayload = {
        [FORM_TYPE]: {
          ...submission,
          reference_no: referenceNo,
          intention: finalizedIntention,
          payment_method: paymentMethod,
        },
      };
      console.log("DEBUG submission", submissionPayload);
      axios
        .post(API_PATH, submissionPayload)
        .then(function ({ data }) {
          window.location.replace(
            mkPaymentUrl({
              paymentMethod,
              referenceNo,
              amount,
              name,
              email,
            }),
          );
          console.log("posted resp:", data);
        })
        .catch(function (error) {
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
                {...register("other_intention", {
                  required: false,
                })}
              />
            )}
          </>
        </VStack>
      </Box>

      <HStack>
        <Button
          colorScheme="teal"
          isLoading={isSubmitting}
          onClick={(e) => {
            handleSubmit(onSubmit("fpx"))();
            e.preventDefault();
          }}
        >
          Online Banking
        </Button>

        <Button
          colorScheme="teal"
          isLoading={isSubmitting}
          onClick={(e) => {
            handleSubmit(onSubmit("cybersource"))();
            e.preventDefault();
          }}
        >
          Credit/Debit Card
        </Button>
      </HStack>
    </form>
  );
}
