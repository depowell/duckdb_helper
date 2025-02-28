-- models/demo_date_spline.sql
{{
    config(
        post_hook="""
            {{ export_model_as_csv(this, './demo_date_spline.csv')}}
        """
    )
}}
{{ date_spline('2025-02-28', '2025-03-10') }}
